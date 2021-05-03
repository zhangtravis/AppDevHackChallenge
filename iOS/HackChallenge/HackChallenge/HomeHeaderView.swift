//
//  HomeHeaderView.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit
class HomeHeaderView: UICollectionReusableView {
    private var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // TODO 6a-i: styling for headerView.

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .gray
        addSubview(label)
        
        setupConstraints()
    }
    
    // TODO 6a-ii: constraints for headerView.

    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setTitle(title: String) {
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
