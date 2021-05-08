//
//  PastChallenges.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

//struct Image: Codable {
//    let imageData: Data?
//    
//    init(withImage image: UIImage) {
//        self.imageData = image.pngData()
//    }
//
//    func getImage() -> UIImage? {
//        guard let imageData = self.imageData else {
//            return nil
//        }
//        let image = UIImage(data: imageData)
//        
//        return image
//    }
//}
//
//struct PastChallenge : Codable {
//    var title: String
//    var image: Image
//    var description: String
//    var sender: String
//    var upvotes: Int
//    var downvotes: Int
//}

struct Player : Codable {
    var id: Int
    var name: String
    var username: String
    var password: String
    var points: Int
    var challenges: [Challenge]
    var groups: [Group]
    var authored_challenges: [Challenge]
}

struct Group : Codable {
    var id: Int
    var name: String
    var players: [ Player ]
    var challenges: [Challenge]
}

struct Challenge : Codable {
    var id : Int
    var title : String
    var description: String
    var claimed: Bool
    var completed: Bool
//    var author_id: Int
//    var group_id: Int
    var player: [Player]
}

struct ChallengesResponse : Codable {
    var success : Bool
    var data : [Challenge]
}

//struct PastChallenges : Codable {
//    var success : Bool
//    var data : [Challenge]
//}
