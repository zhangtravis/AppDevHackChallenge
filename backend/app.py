import json

from flask import Flask, jsonify, request, redirect, send_file
import os
from PIL import Image
from file import upload_file, list_files

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

@app.route("/api/players/", methods=["POST"])
def create_player():
    body = json.loads(request.data)
    name = body.get('name')
    username = body.get('username')
    password = body.get('password')

    if name is None or username is None or password is None:
        return failure_response("Name, username, or password not provided")

    new_player = Player(name=name, username=username, password=password)
    db.session.add(new_player)
    db.session.commit()
    return success_response(new_player.serialize(), 201)

@app.route("/api/players/<int:player_id>/", methods=["DELETE"])
def delete_player(player_id):
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")
    db.session.delete(player)
    db.session.commit()
    return success_response(player.serialize())

@app.route("/api/players/<int:player_id>/challenge/")
def get_current_challenge(player_id):
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")
    return success_response([c.serialize() for c in player.challenges if not c.completed])

@app.route("/api/players/<int:player_id>/challenge", methods=["DELETE"])
def delete_current_challenge(player_id):
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")
    c = get_current_challenge(player.id)
    if c is None:
        return failure_response("No current challenge")
    db.session.delete(c)
    db.session.commit()
    return success_response(c.serialize())

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

@app.route("/api/challenges/", methods=["POST"])
def create_challenge():
    body = json.loads(request.data)
    title = body.get('title')
    description = body.get('description')
    author_id = body.get('author_id')
    group_id = body.get('group_id')

    if title is None or description is None or author_id is None or group_id is None:
        return failure_response("Title or description or author_id or group_id not provided")

    new_challenge = Challenge(title=title, description=description, author_id=author_id, group_id=group_id)
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

@app.route("/challenges/<int:challenge_id>/<int:player_id>/")
def assign_challenge_to_player(challenge_id, player_id):
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
        return failure_response("name not provided")

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

"""
File upload route
"""
@app.route('/upload/', methods=['POST'])
def upload():
    f = request.files['file']
    if f is None:
        return failure_response('No Image!')
    img = Image.open(f)
    asset = Asset(file=img)
    db.session.add(asset)
    db.session.commit()
    return success_response(asset.serialize(), 201)

# @app.route("/storage/")
# def storage():
#     contents = list_files(bucket_name)
#     return success_response(contents)

# @app.route("/upload/", methods=['POST'])
# def upload():
#     if request.method == "POST":
#         f = request.files['file']
#         f.save(os.path.join(upload_folder, f.filename))
#         response = upload_file(f"{upload_folder}/{f.filename}", bucket_name)

#         return response


if __name__ == "__main__":
    # port = os.environ.get('PORT', 500)
    # app.run(host="0.0.0.0", port=port)
    app.run(host="0.0.0.0", port=5000, debug=True)
