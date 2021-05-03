//
//  CurrentChallenge.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

class CurrentChallenge {
    var title: String
    var description: String
    var sender: String
    var selected: Bool

    init(title: String, description: String, sender: String) {
        self.title = title
        self.description = description
        self.sender = sender
        self.selected = false
    }
}
