//
//  GroupsCollectionViewCell.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/8/21.
//

import UIKit

class GroupsCollectionViewCell: UICollectionViewCell {
    private var groupLabelView : UIView = UIView()
    private var groupLabel : UILabel = UILabel()
    private var leaveButton : UIButton = UIButton()
    
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let challengeBlueCG = CGColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let challengeRed = UIColor(red: 237/255, green: 72/255, blue: 72/255, alpha: 1)
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        groupLabelView.translatesAutoresizingMaskIntoConstraints = false
        groupLabelView.layer.cornerRadius = 5
        groupLabelView.backgroundColor = .white
        contentView.addSubview(groupLabelView)
        
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        groupLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        groupLabel.textAlignment = .center
        groupLabel.textColor = .black
        contentView.addSubview(groupLabel)
        
        leaveButton.setTitle("LEAVE GROUP", for: .normal)
        leaveButton.setTitleColor(.white, for: .normal)
        leaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        leaveButton.backgroundColor = challengeRed
        leaveButton.layer.cornerRadius = 5
        leaveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leaveButton)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            groupLabelView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            groupLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            groupLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            groupLabelView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            groupLabelView.widthAnchor.constraint(equalToConstant: 108),
            groupLabelView.trailingAnchor.constraint(equalTo: leaveButton.leadingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            groupLabel.centerXAnchor.constraint(equalTo: groupLabelView.centerXAnchor),
            groupLabel.centerYAnchor.constraint(equalTo: groupLabelView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            leaveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            leaveButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            leaveButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            leaveButton.leadingAnchor.constraint(equalTo: groupLabelView.trailingAnchor, constant: 4),
            leaveButton.widthAnchor.constraint(equalToConstant: 108)
        ])
    }
    
    func configure(for group: Group) {
        groupLabel.text = group.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
