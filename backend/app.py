import json

from flask import Flask
from flask import jsonify
from flask import request

from db import db
from db import Player

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

@app.route("/")
def get_players():
    return success_response([t.serialize() for t in Player.query.all()]) 


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
