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
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    
    override init(frame: CGRect) {
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
        
        completedTitleLabel.text = "Challenges Completed"
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
            challengerTitleLabel.heightAnchor.constraint(equalToConstant: 28)

        ])
        NSLayoutConstraint.activate([
            completedTitleLabel.trailingAnchor.constraint(equalTo: leaderboardView.trailingAnchor,constant: -20),
            completedTitleLabel.topAnchor.constraint(equalTo: leaderboardLabel.bottomAnchor, constant: 18),
            completedTitleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        NSLayoutConstraint.activate([
            challengerLabel.leadingAnchor.constraint(equalTo: leaderboardView.leadingAnchor,constant: 20),
            challengerLabel.topAnchor.constraint(equalTo: challengerTitleLabel.bottomAnchor, constant: 0),
            challengerLabel.widthAnchor.constraint(equalToConstant: 140),
            challengerLabel.heightAnchor.constraint(equalToConstant: 140)

        ])
        NSLayoutConstraint.activate([
//            completedLabel.trailingAnchor.constraint(equalTo: leaderboardView.trailingAnchor,constant: -20),
            completedLabel.centerXAnchor.constraint(equalTo: completedTitleLabel.centerXAnchor),
            completedLabel.topAnchor.constraint(equalTo: completedTitleLabel.bottomAnchor, constant: 0),
            completedLabel.widthAnchor.constraint(equalToConstant: 100),
            completedLabel.heightAnchor.constraint(equalToConstant: 140)
        ])
        
    }

    func configure(for board: Leaderboard) {
        leaderboardLabel.text = board.groupName
        //MARK: Make 5 different labels for each challenger and # completed
        var players = ""
        var complete = ""
//        for playerRank in board.rankings {
//            if players.count != 0 {
//                players = players + "\n" + playerRank.rank[0]
//                complete = complete + "\n" + playerRank.rank[1]
//            }
//            else {
//                players = playerRank.rank[0]
//                complete = playerRank.rank[1]
//            }
//        }
        challengerLabel.text = players
        completedLabel.text = complete
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
