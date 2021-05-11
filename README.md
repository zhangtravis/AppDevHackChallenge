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
            "points": 0,
            "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "groups": [ <SERIALIZED GROUP>, ... ],
            "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "image": {
                "url": <URL HERE>,
                "created_at": <DATETIME STRING HERE>,
                "challenge_id": null,
                "player_id": 1
            }
        },
        {
            "id": 2,
            "name": "test name 2",
            "username": "user2",
            "points": 0,
            "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "groups": [ <SERIALIZED GROUP>, ... ],
            "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ],
            "image": {
                "url": <URL HERE>,
                "created_at": <DATETIME STRING HERE>,
                "challenge_id": null,
                "player_id": 2
            }
        }
        ...
    ]
}
```

In this route, `challenge_id` in the image branch will be `null` because the image is associated with the player and not the challenge.

## Get player by id

**GET** `/api/players/{player_id}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "username": "test username",
        "points": 0,
        "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "groups": [ <SERIALIZED GROUP>, ... ],
        "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "image": {
            "url": <URL HERE>,
            "created_at": <DATETIME STRING HERE>,
            "challenge_id": null,
            "player_id": 1
        }
    }
}
```

In this route, `challenge_id` in the image branch will be `null` because the image is associated with the player and not the challenge.

## Delete player by id

**DELETE** `/api/players/{player_id}/`

Response: No Response if successful

## Get player by username

**GET** `/api/players/{player_username}/`

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "username": "test username",
        "points": 0,
        "current challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "completed challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "groups": [ <SERIALIZED GROUP>, ... ],
        "authored_challenges": [ <SERIALIZED CHALLENGE>, ... ],
        "image": {
            "url": <URL HERE>,
            "created_at": <DATETIME STRING HERE>,
            "challenge_id": null,
            "player_id": 1
        }
    }
}
```

In this route, `challenge_id` in the image branch will be `null` because the image is associated with the challenge and not the player.

## Create a player

**POST** `/api/players/`

Allowable files: `.png`, `.jpeg`, `.jpe`, `.jpg`, `.gif`

Request:

```
{
    "username": <USER INPUT>,
    "password": <USER INPUT>,
    "image_data": <USER INPUT (HAS TO BE BASE64 ENCODED)>
}
```

Response:

```
{
    "success": true,
    "data": {
        "id": 1,
        "username": "test username",
        "points": 0,
        "current challenges": [ ],
        "completed challenges": [ ],
        "groups": [ ],
        "authored_challenges": [ ],
        "image": {
            "url": <URL HERE>,
            "created_at": <DATETIME STRING HERE>,
            "challenge_id": null,
            "player_id": 1
        }
    }
}
```

In this route, `challenge_id` in the image branch will be `null` because the image is associated with the player and not the challenge.

## Login

**POST** `/api/login/`

Request:

```
{
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
        "username": "test username",
        "points": 0,
        "current challenges": [ ],
        "completed challenges": [ ],
        "groups": [ ],
        "authored_challenges": [ ],
        "image": {
            "url": <URL HERE>,
            "created_at": <DATETIME STRING HERE>,
            "challenge_id": null,
            "player_id": 1
        }
    }
}
```

In this route, `challenge_id` in the image branch will be `null` because the image is associated with the challenge and not the player.

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
            "image": null
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
            "image": null
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
            "image": <CAN BE NULL OR SERIALIZED IMAGE>
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
            "image": <CAN BE NULL OR SERIALIZED IMAGE>
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
            "image": null
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
            "image": null
        }
        ...
    ]
}
```

`image` is null because it has not been completed yet.

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
            "image": [ <SERIALIZED IMAGE> ]
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
            "image": [ <SERIALIZED IMAGE> ]
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
        "player": [ <SERIALIZED PLAYER>],
        "image": <CAN BE NULL OR SERIALIZED IMAGE>
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
        "player": [ <SERIALIZED PLAYER>],
        "image": null
    }
}
```

`image` is null because it has not been completed yet.

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
        "player": [ <SERIALIZED PLAYER>],
        "image": null
    }
}
```

`image` is null because it has not been completed yet.

## Create a challenge

**POST** `/api/challenges/`

Request:

```
{
    "title": <USER INPUT>,
    "description": <USER INPUT>,
    "username": <USER INPUT>,
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
        "player": [ ],
        "image": null
    }
}
```

By default, `image` is null because it has not been completed yet.

## Assign challenge to player by ids

**POST** `/api/challenges/assign_challenge_player/`

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
        "player": [<SERIALIZED PLAYER> ],
        "image": null
    }
}
```

## Mark challenge completed by id

**POST** `/api/challenges/mark_completed/`

Allowable files: `.png`, `.jpeg`, `.jpe`, `.jpg`, `.gif`

Request:

```
{
    "challenge_id": <USER INPUT>,
    "image_data": <USER INPUT (HAS TO BE BASE64 ENCODED)>
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
        "player": [<SERIALIZED PLAYER> ],
        "image": {
            "url": <URL HERE>,
            "created_at": <DATETIME STRING HERE>,
            "challenge_id": 1,
            "player_id": null
        }
    }
}
```

In this route, `player_id` in the image branch will be `null` because the image is associated with the challenge and not the player.

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


## Delete player from group by ids

**DELETE** `/api/groups/group_id/player_id/`

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
