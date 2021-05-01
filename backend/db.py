from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Player(db.Model):
    __tablename__ = 'player'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    username = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    points = db.Column(db.Integer, nullable=False)

    def __init__(self, **kwargs):
        self.name = kwargs.get('name')
        self.username = kwargs.get('username')
        self.password = kwargs.get('password')
        self.points = 0

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "username": self.username,
            "points": self.points
        }

class Challenge(db.Model):
    __tablename__ = 'player'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    points_value = db.Column(db.Integer, nullable=False)

    def __init__(self, **kwargs):
        self.name = kwargs.get('name')
        self.description = kwargs.get('description')
        self.points_value = kwargs.get('points_value')

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "points": self.points
        }