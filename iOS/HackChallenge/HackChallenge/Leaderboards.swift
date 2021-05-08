//
//  Leaderboards.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/8/21.
//

import UIKit

class Leaderboard {
    var groupName: String
    var players : [String]
    var completed : [Int]

    init(groupName: String, players: [String], completed : [Int]) {
        self.groupName = groupName
        self.players = players
        self.completed = completed
    }
}

