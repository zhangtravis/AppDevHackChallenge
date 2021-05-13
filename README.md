# AppDevHackChallenge

**App:** Challenge with Friends

**Tagline:** Do some challenges with friends!

**Github link:** https://github.com/zhangtravis/AppDevHackChallenge

**Android Github link:** https://github.com/BenHarris4848/AppDevHackChallengeAndroid

**Screenshots:**
  
![Imgur](https://i.imgur.com/9AArBbPl.png) ![Imgur](https://i.imgur.com/A2D6fSsl.png)


![Imgur](https://i.imgur.com/A5wZrXqm.png)

![Imgur](https://i.imgur.com/1eIB6C2m.png)

![Imgur](https://i.imgur.com/hxgcl4ym.png)

![Imgur](https://i.imgur.com/eJ4Y3nwm.png)

![Imgur](https://i.imgur.com/5gZ4nJum.png)

![Imgur](https://i.imgur.com/pT8vlnYm.png)

![Imgur](https://i.imgur.com/u2dEi8Lm.png)

**Short Description:**

Challenges with friends is an app where you can do challenges, with friends. 
A player can sign up with a username and password, and login every time afterward from that point. 
They can then navigate between different screens based on what action they want to take next: look 
for a challenge to claim, complete a challenge by uploading photo proof, propose a new challenge that 
another player will claim, or look at their positional ranking on both the global leaderboard and the group 
leaderboard for whatever groups they are a part of. There is also a profile page where a player can manage which 
groups they are a part of.

**List of how app addresses each of the requirements:**

For backend, the app addresses the 4 endpoint minimum requirements because we have 25 endpoints, specified in the API Specification ReadMe file in the backend folder. We also have relational database schema using SQLAlchemy - we have 4 tables, for Players, Challenges, Groups, and Assets. We have relationships between tables: 
- There is a one-to-many relationship between a player and all of the challenges they claimed. 
- There is a one-to-many relationship between a player and all of the challenges they authored, 
- There is a many-to-many relationship between players and the groups they are a part of, as they can be a part of multiple groups and a single group can have multiple players in it.
- There is a relationship between players and assets because each player can have a profile photo image
- There is a relationship between challenges and assets, because each completed challenge has an image proof from the player that completed it.
- There is a relationship between challenges and groups, since some challenges are created with the scope of one group in mind (as opposed to a global challenge)

For iOS: 
- AutoLayout using NSLayoutConstraint for the following files
	- ViewController.swift
	- SubmitChallengeViewController.swift
	- PastChallengesCollectionViewCell.swift
	- CurrentChallengeCollectionViewCell.swift
	- SearchViewController.swift
	- GroupFilterCollectionViewCell.swift
	- UnclaimedChallengeTableViewCell.swift
	- ChallengeViewController.swift
	- LeaderboardViewController.swift
	- LeaderboardCollectionViewCell.swift
	- ProfileViewController.swift
	- LogInViewController.swift
	- GroupsCollectionViewCell.swift
- 5 UICollectionView
	- currentCollectionView
	- pastCollectionView
	- groupFilterCollectionView
	- leaderboardCollectionView
	- groupsCollectionView
- 1 UITableView
	- unclaimedChallengesTableView
	- UITabBarController to navigate between screens

For Android:
- 7 unique screens, using fragment tab navigation
- 4 recycler views, 3 unique layout files used by these views, 2 unique adapters
- Persistent data 
- Networking
