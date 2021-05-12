//
//  LeaderboardCollectionViewCell.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/8/21.
//

import UIKit

class LeaderboardCollectionViewCell: UICollectionViewCell {
    private var leaderboardView: UIView = UIView()
    private var leaderboardLabel: UILabel = UILabel()
    private var challengerLabel: UILabel = UILabel()
    private var completedLabel: UILabel = UILabel()
    private let challengerTitleLabel: UILabel = UILabel()
    private let completedTitleLabel: UILabel = UILabel()
    private let playerLabel : UILabel = UILabel()
    private let pointsLabel : UILabel = UILabel()
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
//    private var currentPlayer : PlayerData =
    
    var player: PlayerData! {

        didSet {
            print("pass player info")
        }
    }
        
    override init(frame: CGRect) {
//        self.currentPlayer = player
        super.init(frame: frame)
        
        leaderboardView.translatesAutoresizingMaskIntoConstraints = false
        leaderboardView.layer.masksToBounds = true
        leaderboardView.layer.cornerRadius = 10
        leaderboardView.backgroundColor = challengeBlue
        contentView.addSubview(leaderboardView)
        
        leaderboardLabel.translatesAutoresizingMaskIntoConstraints = false
        leaderboardLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        leaderboardLabel.textColor = .white
        contentView.addSubview(leaderboardLabel)
        
        challengerTitleLabel.text = "Challenger"
        challengerTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        challengerTitleLabel.textColor = .white
        challengerTitleLabel.textAlignment = .right
        challengerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(challengerTitleLabel)
        
        completedTitleLabel.text = "Points"
        completedTitleLabel.textColor = .white
        completedTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        completedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completedTitleLabel)
        
        challengerLabel.translatesAutoresizingMaskIntoConstraints = false
        challengerLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        challengerLabel.textColor = .white
        challengerLabel.textAlignment = .left
        challengerLabel.numberOfLines = 5
        challengerLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(challengerLabel)
        
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        completedLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        completedLabel.textColor = .white
        completedLabel.textAlignment = .center
        completedLabel.numberOfLines = 5
        completedLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(completedLabel)
        
        playerLabel.text = ""
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        playerLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        playerLabel.textColor = .white
        contentView.addSubview(playerLabel)
        
        pointsLabel.text = ""
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        pointsLabel.textColor = .white
        pointsLabel.textAlignment = .center
        
        contentView.addSubview(pointsLabel)
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            leaderboardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leaderboardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leaderboardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            leaderboardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            leaderboardLabel.centerXAnchor.constraint(equalTo: leaderboardView.centerXAnchor),
            leaderboardLabel.topAnchor.constraint(equalTo: leaderboardView.topAnchor, constant: 15),

        ])
        NSLayoutConstraint.activate([
            challengerTitleLabel.leadingAnchor.constraint(equalTo: leaderboardView.leadingAnchor,constant: 20),
            challengerTitleLabel.topAnchor.constraint(equalTo: leaderboardLabel.bottomAnchor, constant: 18),
            challengerTitleLabel.heightAnchor.constraint(equalToConstant: 14)

        ])
        NSLayoutConstraint.activate([
            completedTitleLabel.trailingAnchor.constraint(equalTo: leaderboardView.trailingAnchor,constant: -20),
            completedTitleLabel.topAnchor.constraint(equalTo: leaderboardLabel.bottomAnchor, constant: 18),
            completedTitleLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
        NSLayoutConstraint.activate([
            challengerLabel.leadingAnchor.constraint(equalTo: leaderboardView.leadingAnchor,constant: 20),
            challengerLabel.topAnchor.constraint(equalTo: challengerTitleLabel.bottomAnchor, constant: 0),
            challengerLabel.widthAnchor.constraint(equalToConstant: 140),
            challengerLabel.heightAnchor.constraint(equalToConstant: 100)

        ])
        NSLayoutConstraint.activate([
//            completedLabel.trailingAnchor.constraint(equalTo: leaderboardView.trailingAnchor,constant: -20),
//            completedLabel.centerXAnchor.constraint(equalTo: completedTitleLabel.centerXAnchor),
            completedLabel.topAnchor.constraint(equalTo: completedTitleLabel.bottomAnchor, constant: 0),
            completedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            completedLabel.widthAnchor.constraint(equalToConstant: 100),
            completedLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            pointsLabel.topAnchor.constraint(equalTo: completedLabel.bottomAnchor, constant: 5),
            pointsLabel.centerXAnchor.constraint(equalTo: completedLabel.centerXAnchor),
            pointsLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            playerLabel.topAnchor.constraint(equalTo: challengerLabel.bottomAnchor, constant: 5),
            playerLabel.leadingAnchor.constraint(equalTo: leaderboardView.leadingAnchor,constant: 20)
        ])
        
    }

    func configure(for board: Leaderboard) {
        print("in configure")
        leaderboardLabel.text = board.groupName
        //MARK: Make 5 different labels for each challenger and # completed
        var players = ""
        var complete = ""
        var counter = 1
        print("before for")
        var player_points = "empty"
        for playerRank in board.rankings {
            if players.count != 0 && counter <= 5 {
                print("enter appending")
                players = players + "\n" + playerRank[0]
                complete = complete + "\n" + playerRank[1]
            }
            else {
                print("enter first data is " + playerRank[0] + " " + playerRank[1])
                players = playerRank[0]
                complete = playerRank[1]
            }
            if playerRank[0] == player.username {
                player_points = playerRank[1]
            }
            counter = counter + 1
        }
//        let player = (self.navigationController?.tabBarController as! TabBarController).player
        challengerLabel.text = players
        playerLabel.text = "Your Rank: \(player.username)"
        completedLabel.text = complete
        pointsLabel.text = player_points
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
