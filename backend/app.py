import json

from flask import Flask
from flask import jsonify
from flask import request

from db import db
from db import Player, Challenge

app = Flask(__name__)
db_filename = "game.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}), code

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code


@app.route("/api/players/")
def get_players():
    return success_response([t.serialize() for t in Player.query.all()]) 

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


@app.route("/api/challenges/")
def get_challenges():
    challenges = [c.serialize() for c in Challenge.query.all()]
    return success_response(challenges)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
