//
//  PastChallenges.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

struct GroupResponse : Codable {
    var success : Bool
    var data : Group
}

struct Challenge : Codable {
    var id : Int
    var title : String
    var description: String
//    var claimed: Bool
//    var completed: Bool
    var author_username: String
//    var author_id: Int
//    var group_id: Int
    var player: [ChallengePlayer]
    var image : AppImage?
}
struct Group : Codable {
    var id: Int
    var name: String
//    var players: [ Player ]
    var challenges: [Challenge]?
}

struct AppImage : Codable {
    var url : String
//    var created_at : String
//    var challenge_id : Int?
//    var player_id : Int?
}

struct Player : Codable {
    var id: Int
    var username: String
//    var points: Int
//    var challenges: [Challenge]
    var groups: [Group]
//    var authored_challenges: [Challenge]
    var image : AppImage
}

struct PlayerResponse : Codable {
    var success : Bool
    var data : Player
}
struct ChallengePlayer : Codable {
    var id: Int
    var username: String
    var points : Int
}

struct ChallengeResponse : Codable {
    var success : Bool
    var data : Challenge
}

struct ChallengesResponse : Codable {
    var success : Bool
    var data : [Challenge]
}

//struct PlayerRank : Codable {
////    var user : String
////    var points : String
//    var rank : [String]
//}

struct LeaderboardResponse : Codable {
    var success : Bool
    var data : [[String]]
}

