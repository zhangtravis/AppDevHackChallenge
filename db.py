from flask_sqlalchemy import SQLAlchemy
import base64
import boto3
import datetime
from io import BytesIO
from mimetypes import guess_extension, guess_type
import os
from PIL import Image, ImageFile
ImageFile.LOAD_TRUNCATED_IMAGES = True
import random
import re
import string
import bcrypt

db = SQLAlchemy()

EXTENSIONS = ['png', 'gif', 'jpg', 'jpeg', 'jpe']
BASE_DIR = os.getcwd()
S3_BUCKET = 'appdevhackchallenge'
S3_BASE_URL = f'https://{S3_BUCKET}.s3-us-west-1.amazonaws.com'

player_challenge_assoc = db.Table(
    'player_challenge_assoc',
    db.Column('player_id', db.Integer, db.ForeignKey('player.id')),
    db.Column('challenge_id', db.Integer, db.ForeignKey('challenge.id'))
)

player_group_assoc = db.Table(
    'player_group_assoc',
    db.Column('player_id', db.Integer, db.ForeignKey('player.id')),
    db.Column('group_id', db.Integer, db.ForeignKey('group.id'))
)

player_image_assoc = db.Table(
    'player_image_assoc',
    db.Column('player_id', db.Integer, db.ForeignKey('player.id')),
    db.Column('asset_id', db.Integer, db.ForeignKey('asset.id'))
)

challenge_image_assoc = db.Table(
    'challenge_image_assoc',
    db.Column('challenge_id', db.Integer, db.ForeignKey('challenge.id')),
    db.Column('asset_id', db.Integer, db.ForeignKey('asset.id'))
)

class Player(db.Model):
    """
    Class used to represent Players Database

    Attributes:
    -------
    id: Database column to denote the IDs of each player
    name: Database column to denote the names of each player
    username: Database column for usernames of each player
    password_digest: Database column for passwords (encoded) of each player
    points: Database column for # of points each player has
    challenges: Denotes what challenge the player is currently doing
    groups: Denotes what groups the player is in
    authored_challenges: Denoted which challenges were created by a player
    asset: Stores a profile picture for a player
    """

    __tablename__ = 'player'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    password_digest = db.Column(db.String, nullable=False)
    points = db.Column(db.Integer, nullable=False)
    challenges = db.relationship('Challenge',  secondary=player_challenge_assoc, back_populates='player')
    groups = db.relationship('Group',  secondary=player_group_assoc, back_populates='players')
    authored_challenges = db.relationship("Challenge", cascade="delete")
    asset = db.relationship('Asset', secondary=player_image_assoc, uselist=False, cascade="delete")

    def __init__(self, **kwargs):
        """
        Initialize variables
        """
        self.username = kwargs.get('username')
        self.password_digest = bcrypt.hashpw(kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13))
        self.points = 0

    def verify_password(self, password):
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)

    def serialize(self):
        """
        Return serialized data
        """
        return {
            "id": self.id,
            "username": self.username,
            "points": self.points,
            "current_challenges": [c.serialize_condensed() for c in self.challenges if not c.completed],
            "completed_challenges": [c.serialize_condensed() for c in self.challenges if c.completed],
            "groups": [g.serialize_condensed() for g in self.groups],
            "authored_challenges": [c.serialize_condensed() for c in self.authored_challenges],
            "image": self.asset.serialize() if self.asset != None else None
        }
    
    def serialize_condensed(self):
        """
        Return serialized data
        """
        return {
            "id": self.id,
            "username": self.username,
            "points": self.points,
        }

class Challenge(db.Model):
    """
    Class used to represent Challenge Database

    Attributes:
    -------
    id: Database column to denote the IDs of each challenge
    title: Database column to denote the title of each challenge
    description: Database column for description of each challenge
    claimed: Database column for whether a challenge has been claimed or not
    completed: Database column for whether a challenge has been completed or not
    author_username: Database column for the author username for a challenge
    author_id: Database Column for the author id for a challenge
    group_id: Database Column for group id for a challenge
    player: Denotes what player is partaking in a challenge right now
    asset: Ties a picture to a challenge
    """
    
    __tablename__ = 'challenge'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    claimed = db.Column(db.Boolean, default=False, nullable=False)
    completed = db.Column(db.Boolean, default=False, nullable=False)
    author_username = db.Column(db.String, nullable=False)
    author_id = db.Column(db.Integer, db.ForeignKey("player.id"), nullable=False)
    group_id = db.Column(db.Integer, db.ForeignKey("group.id"))
    player = db.relationship('Player', secondary=player_challenge_assoc, back_populates='challenges')
    asset = db.relationship('Asset', secondary=challenge_image_assoc, uselist=False, cascade="delete")

    def __init__(self, **kwargs):
        """
        Initialize variables
        """
        self.title = kwargs.get('title')
        self.description = kwargs.get('description')
        self.claimed = kwargs.get('claimed', False)
        self.completed = kwargs.get('completed', False)
        self.author_username = kwargs.get('author_username')
        self.author_id = kwargs.get('author_id')
        self.group_id = kwargs.get('group_id')

    def serialize(self):
        """
        Return serialized data
        """
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "claimed": self.claimed,
            "completed": self.completed,
            "author_username": self.author_username,
            "author_id": self.author_id,
            "group_id": self.group_id,
            "player": [p.serialize_condensed() for p in self.player],
            "image": self.asset.serialize() if self.asset != None else None
        }

    def serialize_condensed(self):
        """
        Return serialized data
        """
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "claimed": self.claimed,
            "completed": self.completed,
            "author_username": self.author_username,
            "author_id": self.author_id,
            "group_id": self.group_id,
            "image": self.asset.serialize() if self.asset != None else None
        }

class Group(db.Model):
    """
    Class used to represent Group Database

    Attributes:
    -------
    id: Database column to denote the IDs of each group
    name: Database column for name of each group
    players: Stores all players in the group
    local_challenges: Stores all challenges within the group
    """

    __tablename__ = 'group'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    players = db.relationship('Player',  secondary=player_group_assoc, back_populates='groups')
    local_challenges = db.relationship("Challenge", cascade="delete")

    def __init__(self, **kwargs):
        """
        Initialize variables
        """
        self.name = kwargs.get('name')

    def serialize(self):
        """
        Return serialized data
        """
        return {
            "id": self.id,
            "name": self.name,
            "players": [p.serialize_condensed() for p in self.players],
            "challenges": [c.serialize_condensed() for c in self.local_challenges]
        }

    def serialize_condensed(self):
        """
        Return serialized data
        """
        return {
            "id": self.id,
            "name": self.name
        }

class Asset(db.Model):
    """
    Class used to represent Asset Database (uploading to/downloading from AWS)

    Attributes:
    -------
    id: Database column to denote the IDs of each file
    base_url: Database column for base_url of each file
    salt: Database column that represent unique identifier for images
    extension: Database column to store the extensions in each file
    height: Database column for image height
    width: Database column for image width
    created_at: Database column for when file was created
    player_id: Database column for player id (CAN BE NULL)
    challenge_id: Database column for challenge id (CAN BE NULL)
    """

    __tablename__ = 'asset'
    id = db.Column(db.Integer, primary_key=True)
    base_url = db.Column(db.String, nullable=False)
    salt = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    width = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    player_id = db.Column(db.Integer, nullable=True)
    challenge_id = db.Column(db.Integer, nullable=True)

    def __init__(self, **kwargs):
        """
        Initialize variables
        """
        self.create(kwargs.get('image_data'))
        self.challenge_id = kwargs.get('challenge_id', None)
        self.player_id = kwargs.get('player_id', None)

    def serialize(self):
        """
        Return serialized data
        """
        return {
            'url': f'{self.base_url}/{self.salt}.{self.extension}',
            'created_at': str(self.created_at),
            'challenge_id': self.challenge_id if hasattr(self, 'challenge_id') else None,
            'player_id': self.player_id if hasattr(self, 'player_id') else None
        }

    def create(self, image_data):
        """
        Tries to create an image from base64 code and upload to Amazon s3 bucket

        @param image_data: base64 encoded data of image
        """
        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]
            if ext not in EXTENSIONS:
                raise Exception(f'Extension {ext} not supported!')
            
            salt = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for i in range(16))
            
            img_str = re.sub("^data:image/.+;base64,", "", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL
            self.salt = salt
            self.extension = ext
            self.height = img.height
            self.width = img.width
            self.created_at = datetime.datetime.now()

            img_filename = f'{salt}.{ext}'
            self.upload(img, img_filename)

        except Exception as e:
            print('Error: ', e)

    def upload(self, img, img_filename):
        """
        Tries to upload image to Amazon s3 bucket

        @param img: the image to upload
        @param img_filename: Filename for image
        """
        try:
            img_tempdir = f'{BASE_DIR}/uploads/'
            img_temploc = f'{img_tempdir}{img_filename}'
            if not os.path.isdir(img_tempdir):
                os.mkdir(img_tempdir)
            img.save(img_temploc)

            s3_client = boto3.client('s3')
            s3_client.upload_file(img_temploc, S3_BUCKET, img_filename)

            s3_resource = boto3.resource('s3')
            object_acl = s3_resource.ObjectAcl(S3_BUCKET, img_filename)
            object_acl.put(ACL="public-read")
            os.remove(img_temploc)

        except Exception as e:
            print('Upload Failed: ', e)