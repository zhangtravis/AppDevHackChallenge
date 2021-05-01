import json

from flask import Flask
from flask import jsonify
from flask import request

app = Flask(__name__)

def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}), code

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code

@app.route("/")
def hello_world():
    return "Hello world!"

@app.route("/api/challenges/")
def get_challenges():
    challenges = [c.serialize() for c in Challenge.query.all()]
    return success_response(challenges)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
