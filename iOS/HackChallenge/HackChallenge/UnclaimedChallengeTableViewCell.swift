//
//  UnclaimedChallengeTableViewCell.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

class UnclaimedChallengeTableViewCell: UITableViewCell {
//    private var challengeView: UIView = UIView()
    private var titleLabel: UILabel = UILabel()
    private var descriptionLabel: UILabel = UILabel()
    private var senderLabel: UILabel = UILabel()
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    
    let grey = UIColor.init(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = challengeBlue
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

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
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 53),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            senderLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            senderLabel.heightAnchor.constraint(equalToConstant: 15),
            senderLabel.widthAnchor.constraint(equalToConstant: 300),
            senderLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor)
        ])

        
    }
    
    func configure(with challenge: Challenge) {
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.description

        var sender_name = ""
        NetworkManager.getPlayerById(id: challenge.author_id, completion: { (sender) in
            print("GET ID of " + sender.username + " is \(challenge.author_id)")
            
            sender_name = sender.username
            self.senderLabel.text = "Challenged by: " + sender_name
            
        })
//        print("test")
//        print(sender_name)
//        senderLabel.text = "Challenged by: " + sender_name
  
//        challenge.author_id
//        print (challenge.player.count)
            //+ challenge.player[0].name
//            + player.username
           

    }

    
}
