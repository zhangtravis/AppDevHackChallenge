from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

player_challenge_assoc = db.Table(
    'player_challenge_assoc',
    db.Column('player_id', db.Integer, db.ForeignKey('player.id')),
    db.Column('challenge_id', db.Integer, db.ForeignKey('challenge.id'))
)

class Player(db.Model):
    """
    Class used to represent Players Database

    Attributes:
    -------
    id: Database column to denote the IDs of each player
    name: Database column to denote the names of each player
    username: Database column for usernames of each player
    password: Database column for passwords of each player
    points: Database column for # of points each player has
    challenge: Denotes what challenge the player is currently doing
    """

    __tablename__ = 'player'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    username = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    points = db.Column(db.Integer, nullable=False)
    challenges = db.relationship('Challenge',  secondary=player_challenge_assoc, back_populates='player')

    def __init__(self, **kwargs):
        """
        Initialize variables
        """
        self.name = kwargs.get('name')
        self.username = kwargs.get('username')
        self.password = kwargs.get('password')
        self.points = 0

    def serialize(self):
        """
        Return serialized data
        """
        return {
            "id": self.id,
            "name": self.name,
            "username": self.username,
            "points": self.points,
            "current_challenge": [c.serialize() for c in self.challenges if not c.completed],
            "completed_challenges": [c.serialize() for c in self.challenges if c.completed]
        }

class Challenge(db.Model):
    """
    Class used to represent Challenge Database

    Attributes:
    -------
    id: Database column to denote the IDs of each challenge
    title: Database column to denote the title of each challenge
    description: Database column for description of each challenge
    votes: Database column for # of votes (approval rating) for each challenge
    claimed: Database column for whether a challenge has been claimed or not
    player_id: Denotes the id for current player through one-to-one relationship
    player: Denotes what player is partaking in a challenge right now
    """
    
    __tablename__ = 'challenge'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    votes = db.Column(db.Integer, nullable=False)
    claimed = db.Column(db.Boolean, default=False, nullable=False)
    completed = db.Column(db.Boolean, default=False, nullable=False)
    # player_id = db.Column(db.Integer, db.ForeignKey('player.id'))
    player = db.relationship('Player', secondary=player_challenge_assoc, back_populates='challenges')

    def __init__(self, **kwargs):
        """
        Initialize variables
        """
        self.title = kwargs.get('title')
        self.description = kwargs.get('description')
        self.claimed = kwargs.get('claimed', False)
        self.completed = kwargs.get('completed', False)
        self.votes = 0

    def serialize(self):
        """
        Return serialized data
        """
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "votes": self.votes,
            "claimed": self.claimed,
            "completed": self.completed,
            "player": [self.player.serialize()]
        }