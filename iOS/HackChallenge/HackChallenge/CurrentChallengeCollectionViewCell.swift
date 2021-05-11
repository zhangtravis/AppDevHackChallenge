//
//  CurrentChallengeCollectionViewCell.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

class CurrentChallengeCollectionViewCell: UICollectionViewCell {
    
    private var challengeView: UIView = UIView()
    private var titleLabel: UILabel = UILabel()
    private var descriptionLabel: UILabel = UILabel()
    private var senderLabel: UILabel = UILabel()
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        challengeView.translatesAutoresizingMaskIntoConstraints = false
        challengeView.layer.masksToBounds = true
        challengeView.layer.cornerRadius = 10
        challengeView.backgroundColor = challengeBlue
        contentView.addSubview(challengeView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 3

        descriptionLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(descriptionLabel)
        
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        senderLabel.textColor = .white
        senderLabel.textAlignment = .left
        contentView.addSubview(senderLabel)
        
        
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            challengeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            challengeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            challengeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            challengeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: challengeView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: challengeView.topAnchor, constant: 10),

        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: challengeView.leadingAnchor,constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 53),
            descriptionLabel.trailingAnchor.constraint(equalTo: challengeView.trailingAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            senderLabel.bottomAnchor.constraint(equalTo: challengeView.bottomAnchor, constant: -10),
            senderLabel.heightAnchor.constraint(equalToConstant: 15),
            senderLabel.widthAnchor.constraint(equalToConstant: 300),
            senderLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor)
        ])
    }

    func configure(for challenge: Challenge) {
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.description
        var sender_name = ""
        NetworkManager.getPlayerById(id: challenge.author_id, completion: { (sender) in
            print("GET ID of " + sender.username + " is \(challenge.author_id)")
            
            sender_name = sender.username
            self.senderLabel.text = "Challenged by: " + sender_name
            
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
