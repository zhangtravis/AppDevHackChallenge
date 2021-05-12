//
//  GroupFilterCollectionViewCell.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/5/21.
//

import UIKit

class GroupFilterCollectionViewCell: UICollectionViewCell {
    private var groupFilterView : UIView = UIView()
    private var groupFilterLabel : UILabel = UILabel()
    
    
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let challengeBlueCG = CGColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        groupFilterView.translatesAutoresizingMaskIntoConstraints = false
        groupFilterView.layer.cornerRadius = 5
        groupFilterView.backgroundColor = .clear
        groupFilterView.layer.borderColor = challengeBlueCG
        groupFilterView.layer.borderWidth = 1
        contentView.addSubview(groupFilterView)
        
        groupFilterLabel.translatesAutoresizingMaskIntoConstraints = false
        groupFilterLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        groupFilterLabel.textAlignment = .center
        groupFilterLabel.textColor = .black
        contentView.addSubview(groupFilterLabel)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            groupFilterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            groupFilterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            groupFilterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            groupFilterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            groupFilterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            groupFilterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(for groupFilter: GroupFilter) {
        groupFilterView.backgroundColor = groupFilter.selected ? challengeBlue : .clear
        groupFilterLabel.textColor = groupFilter.selected ? .white : .black
        groupFilterLabel.text = groupFilter.group.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
