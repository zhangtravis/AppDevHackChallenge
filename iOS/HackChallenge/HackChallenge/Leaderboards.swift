//
//  Leaderboards.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/8/21.
//

import UIKit

class Leaderboard {
    var groupName: String
//    var rankings : [PlayerRank]
    var rankings : [[String]]
//    init(groupName: String, rankings : [PlayerRank]) {
    init(groupName: String, rankings : [[String]]) {
        self.groupName = groupName
        self.rankings = rankings
    }
}

