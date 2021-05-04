//
//  PastChallengesCollectionViewCell.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

class PastChallengesCollectionViewCell: UICollectionViewCell {
    
    private var challengeView: UIView = UIView()
    private var titleLabel: UILabel = UILabel()
    private var proofImage : UIImageView = UIImageView()
    private var descriptionLabel: UILabel = UILabel()
    private var senderLabel: UILabel = UILabel()
    private var upvotesImageView: UIImageView = UIImageView()
    private var upvotesLabel: UILabel = UILabel()
    private var downvotesImageView: UIImageView = UIImageView()
    private var downvotesLabel: UILabel = UILabel()
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
        
        proofImage.layer.cornerRadius = 5
//        img.layer.borderWidth = 1.0
//        img.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        proofImage.layer.masksToBounds = true
        proofImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(proofImage)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0

        descriptionLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(descriptionLabel)
        
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        senderLabel.textColor = .white
        senderLabel.textAlignment = .left
        contentView.addSubview(senderLabel)
        
        upvotesImageView.translatesAutoresizingMaskIntoConstraints = false
        upvotesImageView.image = UIImage(named: "up_arrow.png")
        contentView.addSubview(upvotesImageView)
        
        downvotesImageView.translatesAutoresizingMaskIntoConstraints = false
        downvotesImageView.image = UIImage(named: "down_arrow.png")
        contentView.addSubview(downvotesImageView)
        
        upvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        upvotesLabel.textColor = .white
        upvotesLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        contentView.addSubview(upvotesLabel)
        
        downvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        downvotesLabel.textColor = .white
        downvotesLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        contentView.addSubview(downvotesLabel)
        
        
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
            proofImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            proofImage.widthAnchor.constraint(equalToConstant: 326),
            proofImage.heightAnchor.constraint(equalToConstant: 147),
            proofImage.centerXAnchor.constraint(equalTo: challengeView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: challengeView.leadingAnchor,constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: proofImage.bottomAnchor, constant: 5),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 53),
            descriptionLabel.trailingAnchor.constraint(equalTo: challengeView.trailingAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            senderLabel.bottomAnchor.constraint(equalTo: challengeView.bottomAnchor, constant: -10),
            senderLabel.heightAnchor.constraint(equalToConstant: 15),
            senderLabel.widthAnchor.constraint(equalToConstant: 300),
            senderLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            downvotesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            downvotesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            downvotesImageView.trailingAnchor.constraint(equalTo: downvotesLabel.leadingAnchor, constant: -5),
            downvotesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            upvotesLabel.trailingAnchor.constraint(equalTo: downvotesImageView.leadingAnchor, constant: -5),
            upvotesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            upvotesImageView.trailingAnchor.constraint(equalTo: upvotesLabel.leadingAnchor, constant: -5),
            upvotesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

    }

    func configure(for challenge: PastChallenge) {
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.description
        proofImage.image = challenge.image.getImage()
        senderLabel.text = "Challenged by: " + challenge.sender
        upvotesLabel.text = String(challenge.upvotes)
        downvotesLabel.text = String(challenge.downvotes)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
