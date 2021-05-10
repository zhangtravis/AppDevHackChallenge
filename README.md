# AppDevHackChallenge

## Get all players

**GET** `/api/players/`

Response:

```
{
    "success": true,
    "data": [
        {
            "id": 1,
            "name": "test name",
            "username": "test username",
            "password": "test password",
            "points": 0,
            "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "groups": [ <SERIALIZED GROUP>, ... ],
            "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ]
        },
        {
            "id": 2,
            "name": "test name 2",
            "username": "uer2",
            "password": "pass2",
            "points": 0,
            "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "groups": [ <SERIALIZED GROUP>, ... ],
            "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ]
        }
        ...
    ]
}
```

## Get player by id

**GET** `/api/players/{player_id}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "name": "test name",
        "username": "test username",
        "password": "test password",
        "points": 0,
        "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "groups": [ <SERIALIZED GROUP>, ... ],
        "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ]
    }
}
```

## Delete player by id

**DELETE** `/api/players/{player_id}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "name": "test name",
        "username": "test username",
        "password": "test password",
        "points": 0,
        "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "groups": [ <SERIALIZED GROUP>, ... ],
        "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ]
    }
}
```

## Get player by username

**GET** `/api/players/{player_username}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "name": "test name",
        "username": "test username",
        "password": "test password",
        "points": 0,
        "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "groups": [ <SERIALIZED GROUP>, ... ],
        "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ]
    }
}
```

## Create a player

**POST** `/api/players/`

Request:

```
{
    "name": <USER INPUT>,
    "username": <USER INPUT>,
    "password": <USER INPUT>
}
```

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "name": "test name",
        "username": "test username",
        "password": "test password",
        "points": 0,
        "current challenges": [ ],
        "completed challenges": [ ],
        "groups": [ ],
        "authored_challenges": [ ]
    }
}
```

## Login

**POST** `/api/login/`

Request:

```
{
    "username": <USER INPUT>,
    "password": <USER INPUT>
}
```

## Get current challenges by player id

**GET** `/api/players/<int:player_id>/challenges/`

Response:

```
{
    "success": true,
    "data": [
        {
           "id": 1,
            "title": "test title",
            "description": "test description",
            "claimed": true,
            "completed": false,
            "author_username": "user1",
            "author_id": 1,
            "group_id": 1,
            "player": [<SERIALIZED PLAYER> ],
        },
        {
            "id": 2,
            "title": "test title",
            "description": "test description",
            "claimed": true,
            "completed": false,
            "author_username": "user1",
            "author_id": 1,
            "group_id": 1,
            "player": [<SERIALIZED PLAYER> ],
        }
        ...
    ]
}
```

## Get all challenges

**GET** `/api/challenges/`

Response:

```
{
    "success": true,
    "data": [
        {
            "id": 1,
            "title": "test title",
            "description": "test description",
            "claimed": false,
            "completed": false,
            "author_username": "user1",
            "author_id": 1,
            "group_id": 1,
            "player": [ ],
        },
        {
            "id": 2,
            "title": "test title",
            "description": "test description",
            "claimed": true,
            "completed": true,
            "author_username": "user1",
            "author_id": 1,
            "group_id": 1,
            "player": [<SERIALIZED PLAYER> ],
        }
        ...
    ]
}
```

## Get unclaimed challenges

**GET** `/api/challenges/unclaimed/`

Response:

```
{
    "success": true,
    "data": [
        {
            "id": 1,
            "title": "test title",
            "description": "test description",
            "claimed": false,
            "completed": false,
            "author_username": "user1",
            "author_id": 1,
            "group_id": 1,
            "player": [ ],
        },
        {
            "id": 2,
            "title": "test title",
            "description": "test description",
            "claimed": false,
            "completed": false,
            "author_username": "user1",
            "author_id": 1,
            "group_id": 1,
            "player": [ ],
        }
        ...
    ]
}
```

## Get completed challenges

**GET** `/api/challenges/completed/`

Response:

```
{
    "success": true,
    "data": [
        {
            "id": 1,
            "title": "test title",
            "description": "test description",
            "claimed": true,
            "completed": true,
            "author_username": "user1",
            "author_id": 1,
            "group_id": 1,
            "player": [ <SERIALIZED PLAYER>],
        },
        {
            "id": 2,
            "title": "test title 2",
            "description": "test description 2",
            "claimed": true,
            "completed": true,
            "author_username": "user2",
            "author_id": 2,
            "group_id": 3,
            "player": [<SERIALIZED PLAYER> ],
        }
        ...
    ]
}
```

## Get challenge by id

**GET** `/api/challenges/{challenge_id}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "title": "test title",
        "description": "test description",
        "claimed": false,
        "completed": false,
        "author_username": "user1",
        "author_id": 1,
        "group_id": 1,
        "player": [ <SERIALIZED PLAYER>]
    }
}
```

## Delete challenge by id

**DELETE** `/api/challenges/{challenge_id}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "title": "test title",
        "description": "test description",
        "claimed": false,
        "completed": false,
        "author_username": "user1",
        "author_id": 1,
        "group_id": 1,
        "player": [ <SERIALIZED PLAYER>]
    }
}
```

## Get challenge by title

**GET** `/api/challenges/{challenge_title}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "title": "test title",
        "description": "test description",
        "claimed": false,
        "completed": false,
        "author_username": "user1",
        "author_id": 1,
        "group_id": 1,
        "player": [ <SERIALIZED PLAYER>]
    }
}
```

## Create a challenge

**POST** `/api/challenges/`

Request:

```
{
    "title": <USER INPUT>,
    "description": <USER INPUT>,
    "author_username": <USER INPUT>,
    "author_id": <USER INPUT>,
    "group_id": <USER INPUT>
}
```

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "title": "test title",
        "description": "test description",
        "claimed": false,
        "completed": false,
        "author_username": "user1",
        "author_id": 1,
        "group_id": 1,
        "player": [ ]
    }
}
```

## Assign challenge to player by ids

**POST** `/api/challenges/assign_player_challenge/`

Request:

```
{
    "player_id": <USER INPUT>,
    "challenge_id": <USER INPUT>,
}
```

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "title": "test title",
        "description": "test description",
        "claimed": true,
        "completed": false,
        "author_username": "user1",
        "author_id": 1,
        "group_id": 1,
        "player": [<SERIALIZED PLAYER> ]
    }
}
```

## Mark challenge completed by id

**POST** `/api/challenges/mark_completed/`

Request:

```
{
    "challenge_id": <USER INPUT>,
}
```

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "title": "test title",
        "description": "test description",
        "claimed": true,
        "completed": true,
        "author_username": "user1",
        "author_id": 1,
        "group_id": 1,
        "player": [<SERIALIZED PLAYER> ]
    }
}
```

## Get all groups

**GET** `/api/groups/`

Response:

```
{
    "success": true,
    "data": [
        {
            "id": 1,
            "name": "test name",
            "players": [ <SERIALIZED PLAYER>, ... ],
            "challenges": [ <SERIALIZED CHALLENGE>, ... ],
        },
        {
            "id": 2,
            "name": "test name 2",
            "players": [ <SERIALIZED PLAYER>, ... ],
            "challenges": [ <SERIALIZED CHALLENGE>, ... ],
        }
        ...
    ]
}
```

## Get group by id

**GET** `/api/groups/{group_id}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "name": "test name",
        "players": [ <SERIALIZED PLAYER>, ... ],
        "challenges": [ <SERIALIZED CHALLENGE>, ... ],
    }
}
```

## Get group by name

**GET** `/api/groups/{group_name}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "name": "test name",
        "players": [ <SERIALIZED PLAYER>, ... ],
        "challenges": [ <SERIALIZED CHALLENGE>, ... ]
    }
}
```

## Create a group

**POST** `/api/groups/`

Request:

```
{
    "name": <USER INPUT>,
}
```

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "name": "test name",
        "players": [ ],
        "challenges": [ ]
    }
}
```

## Assign player to group by ids

**POST** `/api/groups/assign_player_group/`

Request:

```
{
    "player_id": <USER INPUT>,
    "group_id": <USER INPUT>,
}
```

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "name": "test name",
        "players": [<SERIALIZED PLAYER>, ... ],
        "challenges": [<SERIALIZED CHALLENGE>, ...  ]
    }
}
```

## Get group leaderboard in order of points from most to least

**GET** `/api/leaderboard/{group_id}/`

Response:

```
{
    "success": true,
    "data": [ [<USERNAME>, <POINTS>], ... ]
    }
}
```


## Get global leaderboard in order of points from most to least

**GET** `/api/leaderboard/`

Response:

```
{
    "success": true,
    "data": [ [<USERNAME>, <POINTS>], ... ]
    }
}
```


## Upload Image

**POST** `/api/upload/`

Allowable files: `.png`, `.jpeg`, `.jpe`, `.jpg`, `.gif`

Request:

```
{
    "image_data": <USER INPUT (HAS TO BE BASE64 ENCODED)>
}
```

Response:

```
{
    "success": true,
    "data": {
        "url": "url here",
        "created_at": "time here"
    }
}
```
