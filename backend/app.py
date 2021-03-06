import json

from flask import Flask, jsonify, request, redirect, send_file
import os
from PIL import Image

from db import db
from db import Player, Challenge, Asset, Group

app = Flask(__name__)
db_filename = "game.db"
upload_folder = "uploads"
bucket_name = "appdevhackchallenge"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}, default=str), code

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}, default=str), code

@app.route("/")
def hello_world():
    return success_response("HELLO I AM TESTING THIS OUT!!!")

@app.route("/api/players/")
def get_players():
    return success_response([t.serialize() for t in Player.query.all()]) 

@app.route("/api/players/<int:player_id>/")
def get_player(player_id):
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")
    return success_response(player.serialize())

@app.route("/api/players/<string:username>/")
def get_player_by_username(username):
    player = Player.query.filter_by(username=username).first()
    if player is None:
        return failure_response("Player not found!")
    return success_response(player.serialize())

@app.route("/api/players/<string:username>/", methods=["POST"])
def change_player_points(username): # this is only used for video demo purposes
    body = json.loads(request.data)
    points = body.get('points')

    player = Player.query.filter_by(username=username).first()
    if player is None:
        return failure_response("Player not found!")

    player.points = points
    db.session.commit()
    return success_response(player.serialize())

@app.route("/api/players/", methods=["POST"])
def create_player():
    body = json.loads(request.data)
    username = body.get('username')
    password = body.get('password')
    image_data = body.get('image_data')

    if image_data is None:
        return failure_response('No Image!')

    if username is None or password is None:
        return failure_response("Username or password not provided")

    optional_player = Player.query.filter(Player.username == username).first()

    if optional_player is not None:
        return failure_response("Error: Player already exists")

    new_player = Player(username=username, password=password)
    db.session.add(new_player)
    db.session.commit()

    asset = Asset(image_data=image_data, player_id=new_player.id)
    new_player.asset = asset

    db.session.add(asset)
    db.session.commit()
    return success_response(new_player.serialize(), 201)

@app.route('/api/login/', methods=["POST"])
def login():
    body = json.loads(request.data)
    username = body.get('username')
    pw = body.get('password')

    if username is None or pw is None:
        return failure_response("Error: Invalid username or password")

    player = Player.query.filter(Player.username == username).first()
    success = player is not None and player.verify_password(pw)

    if not success:
        return failure_response("Error: Incorrect username or password")
    
    return success_response(player.serialize())

@app.route("/api/players/<int:player_id>/", methods=["DELETE"])
def delete_player(player_id):
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")
    db.session.delete(player)
    db.session.commit()
    return success_response(player.serialize(), 204)

@app.route("/api/players/<int:player_id>/challenges/")
def get_current_challenge(player_id):
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")
    return success_response([c.serialize() for c in player.challenges if not c.completed])

@app.route("/api/challenges/<string:title>/")
def get_challenge_by_name(title):
    challenge = Challenge.query.filter_by(title=title).first()
    if challenge is None:
        return failure_response("Challenge not found!")
    return success_response(challenge.serialize())

@app.route("/api/challenges/unclaimed/")
def get_unclaimed_challenges():
    challenges = [c.serialize() for c in Challenge.query.all() if not c.claimed]
    return success_response(challenges)

@app.route("/api/challenges/completed/")
def get_completed_challenges():
    challenges = [c.serialize() for c in Challenge.query.all() if c.completed]
    return success_response(challenges)


@app.route("/api/challenges/")
def get_challenges():
    challenges = [c.serialize() for c in Challenge.query.all()]
    return success_response(challenges)

@app.route("/api/challenges/<int:challenge_id>/")
def get_challenge(challenge_id):
    challenge = Challenge.query.filter_by(id=challenge_id).first()
    if challenge is None:
        return failure_response("Challenge not found!")
    return success_response(challenge.serialize())

@app.route("/api/challenges/<int:challenge_id>/group/")
def get_group_id_of_challenge(challenge_id):
    challenge = Challenge.query.filter_by(id=challenge_id).first()
    if challenge is None:
        return failure_response("Challenge not found!")
    return success_response(challenge.serialize_group_id())

@app.route("/api/challenges/", methods=["POST"])
def create_challenge():
    body = json.loads(request.data)
    title = body.get('title')
    description = body.get('description')
    author_username = body.get('username')
    author_id = body.get('author_id')
    group_id = body.get('group_id')

    if title is None or description is None or author_id is None or author_username is None or group_id is None:
        return failure_response("Title or description or author_id or group_id not provided")

    new_challenge = Challenge(title=title, description=description, author_id=author_id, author_username=author_username, group_id=group_id)
    db.session.add(new_challenge)
    db.session.commit()
    return success_response(new_challenge.serialize(), 201)

@app.route("/api/challenges/<int:challenge_id>/", methods=["DELETE"])
def delete_challenge(challenge_id):
    challenge = Challenge.query.filter_by(id=challenge_id).first()
    if challenge is None:
        return failure_response("Challenge not found!")
    db.session.delete(challenge)
    db.session.commit()
    return success_response(challenge.serialize())

@app.route("/api/challenges/assign_challenge_player/", methods=["POST"])
def assign_challenge_to_player():
    body = json.loads(request.data)
    player_id = body.get('player_id')
    challenge_id = body.get('challenge_id')
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")

    challenge = Challenge.query.filter_by(id=challenge_id).first()
    if challenge is None:
        return failure_response("Challenge not found!")

    challenge.claimed = True
    player.challenges.append(challenge)
    challenge.player.append(player)
    db.session.commit()
    return success_response(challenge.serialize())

@app.route("/api/groups/")
def get_groups():
    groups = [g.serialize() for g in Group.query.all()]
    return success_response(groups)

@app.route("/api/groups/<string:name>/")
def get_group_by_name(name):
    group = Group.query.filter_by(name=name).first()
    if group is None:
        return failure_response("Group not found!")
    return success_response(group.serialize())

@app.route("/api/groups/<int:group_id>/")
def get_group(group_id):
    group = Group.query.filter_by(id=group_id).first()
    if group is None:
        return failure_response("Group not found!")
    return success_response(group.serialize())

@app.route("/api/groups/", methods=["POST"])
def create_group():
    body = json.loads(request.data)
    name = body.get('name')

    if name is None :
        return failure_response("Group Name not provided")

    optional_group = Group.query.filter(Group.name == name).first()

    if optional_group is not None:
        return failure_response("Error: Group already exists")

    new_group = Group(name=name)
    db.session.add(new_group)
    db.session.commit()
    return success_response(new_group.serialize(), 201)

@app.route("/api/groups/assign_player_group/", methods=["POST"])
def assign_player_to_group():
    body = json.loads(request.data)
    group_id = body.get('group_id')
    player_id = body.get('player_id')
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")

    group = Group.query.filter_by(id=group_id).first()
    if group is None:
        return failure_response("Group not found!")

    player.groups.append(group)
    group.players.append(player)
    db.session.commit()
    return success_response(group.serialize())


@app.route("/api/groups/<int:group_id>/<int:player_id>/", methods=["DELETE"])
def delete_player_from_group(group_id, player_id):
    player = Player.query.filter_by(id=player_id).first()
    group = Group.query.filter_by(id=group_id).first()

    if player is None:
        return failure_response("Player not found!")
    if group is None:
        return failure_response("Group not found!")
    try:
        group.players.index(player)
    except:
        return failure_response("Player not in group!")

    group.players.remove(player)
    db.session.commit()
    group = Group.query.filter_by(id=group_id).first()
    return success_response(group.serialize())


@app.route("/api/leaderboard/<int:group_id>/")
def get_group_leaderboard(group_id):
    group = Group.query.filter_by(id=group_id).first()
    if group is None:
        return failure_response("Group not found!")

    group_players = group.players

    player_points_dict = {}
    for player in group_players:
        player_points_dict[player.username] = player.points
    player_points_lst = sorted(player_points_dict.items(), key=lambda x: x[1], reverse=True)

    alist = []
    for row in range(len(player_points_lst)):
        alist.append([player_points_lst[row][0], str(player_points_lst[row][1])])

    return success_response(alist)

@app.route("/api/leaderboard/")
def get_leaderboard():
    players = Player.query.all()

    player_points_dict = {}
    for player in players:
        player_points_dict[player.username] = player.points
    player_points_lst = sorted(player_points_dict.items(), key=lambda x: x[1], reverse=True)

    alist = []
    for row in range(len(player_points_lst)):
        alist.append([player_points_lst[row][0], str(player_points_lst[row][1])])

    return success_response(alist)

@app.route('/api/challenges/mark_completed/', methods=['POST'])
def mark_completed():
    body = json.loads(request.data)
    image_data = body.get('image_data')
    challenge_id = body.get('challenge_id')

    challenge = Challenge.query.filter_by(id=challenge_id).first()
    if challenge is None:
        return failure_response("Challenge not found")

    if len(challenge.player) == 0:
        return failure_response("A player has not been assigned to the challenge")

    for p in challenge.player:
        challenge_player = p

    if challenge_player is None:
        return failure_response("Challenge has not been claimed yet")

    if challenge.completed == True:
        return failure_response("Challenge already completed")

    challenge.completed = True
    challenge_player.points += 100

    if image_data is None:
        return failure_response('No Image!')
    asset = Asset(image_data=image_data, challenge_id=challenge_id)
    challenge.asset = asset
    db.session.add(asset)
    db.session.commit()
    return success_response(challenge.serialize(), 201)

@app.route("/api/players/update_profile_pic/", methods=["POST"])
def update_profile_pic():
    body = json.loads(request.data)
    player_id = body.get('player_id')
    image_data = body.get('image_data')

    if image_data is None:
        return failure_response('No Image!')

    player = Player.query.filter_by(id=player_id).first()

    if player is None:
        return failure_response("Error: Player does not exist")

    if player.asset is not None:
        db.session.delete(player.asset)
        db.session.commit()

    asset = Asset(image_data=image_data, player_id=player.id)
    player.asset = asset

    db.session.add(asset)
    db.session.commit()
    return success_response(player.serialize(), 201)


if __name__ == "__main__":
    port = os.environ.get('PORT', 5000)
    app.run(host="0.0.0.0", port=port, debug=True)
