//
//  PastChallenges.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

class PastChallenge {
    var title: String
    var image: UIImage
    var description: String
    var sender: String
    var upvotes: Int
    var downvotes: Int
    var selected: Bool

    init(title: String, image: UIImage, description: String, sender: String) {
        self.title = title
        self.image = image
        self.description = description
        self.sender = sender
        self.upvotes = 0
        self.downvotes = 0
        self.selected = false
    }
}
