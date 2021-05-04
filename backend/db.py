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
    player: Denotes what player is partaking in a challenge right now
    """
    
    __tablename__ = 'challenge'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    votes = db.Column(db.Integer, nullable=False)
    claimed = db.Column(db.Boolean, default=False, nullable=False)
    completed = db.Column(db.Boolean, default=False, nullable=False)
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
            "player": [p.serialize() for p in self.player]
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
    """

    __tablename__ = 'asset'
    id = db.Column(db.Integer, primary_key=True)
    base_url = db.Column(db.String, nullable=False)
    salt = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    width = db.Column(db.Integer, nullable=False)
    created_at =db.Column(db.DateTime, nullable=False)

    def __init__(self, **kwargs):
        """
        Initialize variables
        """
        self.create(kwargs.get('image_data'))

    def serialize(self):
        """
        Return serialized data
        """
        return {
            'url': f'{self.base_url}/{self.salt}.{self.extension}',
            'created_at': str(self.created_at)
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
            img_temploc = f'{BASE_DIR}/uploads/{img_filename}'
            img.save(img_temploc)

            s3_client = boto3.client('s3')
            s3_client.upload_file(img_temploc, S3_BUCKET, img_filename)

            s3_resource = boto3.resource('s3')
            object_acl = s3_resource.ObjectAcl(S3_BUCKET, img_filename)
            object_acl.put(ACL="public-read")
            os.remove(img_temploc)

        except Exception as e:
            print('Upload Failed: ', e)
