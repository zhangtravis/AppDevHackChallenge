//
//  CurrentChallengeCollectionViewCell.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

class CurrentChallengeCollectionViewCell: UICollectionViewCell {
    
    private var challengeView: UIView = UIView()
    private var title: UILabel = UILabel()
    private var desc: UILabel = UILabel()
    private var sender: UILabel = UILabel()
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        challengeView.translatesAutoresizingMaskIntoConstraints = false
        challengeView.layer.masksToBounds = true
        challengeView.layer.cornerRadius = 10
        challengeView.backgroundColor = challengeBlue
        contentView.addSubview(challengeView)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title.textColor = .white
        contentView.addSubview(title)
        
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        desc.textColor = .white
        desc.textAlignment = .left
        desc.numberOfLines = 3

        desc.lineBreakMode = .byWordWrapping
        contentView.addSubview(desc)
        
        sender.translatesAutoresizingMaskIntoConstraints = false
        sender.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        sender.textColor = .white
        sender.textAlignment = .left
        contentView.addSubview(sender)
        
        
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
            title.centerXAnchor.constraint(equalTo: challengeView.centerXAnchor),
            title.topAnchor.constraint(equalTo: challengeView.topAnchor, constant: 10),

        ])
        NSLayoutConstraint.activate([
            desc.leadingAnchor.constraint(equalTo: challengeView.leadingAnchor,constant: 10),
            desc.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            desc.heightAnchor.constraint(equalToConstant: 53),
            desc.trailingAnchor.constraint(equalTo: challengeView.trailingAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            sender.bottomAnchor.constraint(equalTo: challengeView.bottomAnchor, constant: -10),
            sender.heightAnchor.constraint(equalToConstant: 15),
            sender.widthAnchor.constraint(equalToConstant: 300),
            sender.leadingAnchor.constraint(equalTo: desc.leadingAnchor)
        ])
    }

    func configure(for challenge: CurrentChallenge) {
        title.text = challenge.title
        desc.text = challenge.description
        sender.text = "Challenged by: " + challenge.sender
        challengeView.layer.opacity = challenge.selected ? 0.8 : 1
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
