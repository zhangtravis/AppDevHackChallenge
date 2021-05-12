//
//  NetworkManager.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import Foundation
import Alamofire


class NetworkManager {
    static let host = "https://challenge-with-friends.herokuapp.com/api/"
    
    static func getAllPastChallenges(completion: @escaping ([Challenge]) -> Void) {
        let endpoint = "\(host)challenges/completed/"
        print("getting past challenges")
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success past")
                let jsonDecoder = JSONDecoder()
                if let challengesResponse = try? jsonDecoder.decode(ChallengesResponse.self, from: data){
                    print("in let past")
                    completion(challengesResponse.data)
                }
                print("out let past")
            case .failure(let error):
                print("failure past")
                print(error.localizedDescription)
            }
        }
    }
    static func getAllUnclaimedChallenges(completion: @escaping ([Challenge]) -> Void) {
        let endpoint = "\(host)challenges/unclaimed/"
        print("GETTING UNCLAIMED CHALLENGES")
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("GETTING UNCLAIMED CHALLENGES SUCC")
                print(data)
                let jsonDecoder = JSONDecoder()
                if let challengesResponse = try? jsonDecoder.decode(ChallengesResponse.self, from: data){
                    completion(challengesResponse.data)
                    print("GETTING UNCLAIMED CHALLENGES IN")
                }
                print("GETTING UNCLAIMED CHALLENGES out")
            case .failure(let error):
                print("GETTING UNCLAIMED CHALLENGES fail")
                print(error.localizedDescription)
            }
        }
    }
    static func getAllCurrentChallenges(playerid: Int, completion: @escaping ([Challenge]) -> Void) {
        let endpoint = "\(host)players/\(playerid)/challenges/"
        print("getting current challenges of \(playerid)")
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success current")
                let jsonDecoder = JSONDecoder()
                if let challengesResponse = try? jsonDecoder.decode(ChallengesResponse.self, from: data){
                    print("in let current")
                    completion(challengesResponse.data)
                }
                print("out let current")
            case .failure(let error):
                print("fail current")
                print(error.localizedDescription)
            }
        }
    }
    
    static func createChallenge(title: String, description: String, author_id: Int, username : String, group_id : String, completion: @escaping (Challenge) -> Void) {
        let endpoint = "\(host)challenges/"
        print("CREATING CHALLENGE")
        let parameters: [String:Any] = [
            "title": title,
            "description": description,
            "author_id": author_id,
            "username" : username,
            "group_id": group_id
        ]
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("CREATING SUCCESS")
                let jsonDecoder = JSONDecoder()
                if let challengeResponse = try? jsonDecoder.decode(ChallengeResponse.self, from: data) {
                    completion(challengeResponse.data)
                    print("IN LET")
                }
                print("OUT LET")
            case .failure(let error):
                print("FAIL")
                print(error.localizedDescription)
            }
        }
    }
    //MARK: Problem
    static func createPlayer(username: String, password: String, image_data: String, completion: @escaping (Player) -> Void) {
        let endpoint = "\(host)players/"
        let parameters: [String:Any] = [
            "username": username,
            "password": password,
            "image_data": image_data
        ]
       print("creating a player")
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success player")
                let jsonDecoder = JSONDecoder()
                if let playerResponse = try? jsonDecoder.decode(PlayerResponse.self, from: data) {
                    print("in let player")
                    completion(playerResponse.data)
                }
                print("out let player")
            case .failure(let error):
                print("fail player")
                print(error.localizedDescription)
            }
        }
    }
    static func logInPlayer(username: String, password: String, completion: @escaping (Player) -> Void) {
        let endpoint = "\(host)login/"
        let parameters: [String:Any] = [
            "username": username,
            "password": password
        ]
        print("Logging in player")
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            print("Logged in player")
            switch response.result {
            case .success(let data):
                print("success login")
                let jsonDecoder = JSONDecoder()
                if let playerResponse = try? jsonDecoder.decode(PlayerResponse.self, from: data) {
                    print("in let login")
                    completion(playerResponse.data)
                }
                print("out let login")
            case .failure(let error):
                print("fail login")
                print(error.localizedDescription)
            }
        }
    }
    static func getPlayerById(id: Int, completion: @escaping (Player) -> Void) {
            let endpoint = "\(host)players/\(id)/"
            AF.request(endpoint, method: .get).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    if let playerResponse = try? jsonDecoder.decode(PlayerResponse.self, from: data){
                        completion(playerResponse.data)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    static func claimChallenge(player_id: Int, challenge_id: Int, completion: @escaping (Challenge) -> Void) {
        let endpoint = "\(host)challenges/assign_challenge_player/"
        let parameters: [String:Any] = [
            "player_id": player_id,
            "challenge_id": challenge_id
        ]
        print("claimed player_id : \(player_id)")
        print("claimed challenge_id : \(challenge_id)")
        print("getting claimed challenge")
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success")
                let jsonDecoder = JSONDecoder()
                if let challengeResponse = try? jsonDecoder.decode(ChallengeResponse.self, from: data) {
                    print("in let")
                    //MARK: not going through let
                    completion(challengeResponse.data)
                }
                print("out let")
            case .failure(let error):
                print("fail")
                print(error.localizedDescription)
            }
        }
    }
    
    static func completeChallenge(challenge_id: Int, image_data: String, completion: @escaping (Challenge) -> Void) {
        let endpoint = "\(host)challenges/mark_completed/"
        let parameters: [String:Any] = [
            "challenge_id": challenge_id,
            "image_data" : image_data
        ]
        print("marking challenge as completed")
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success")
                let jsonDecoder = JSONDecoder()
                if let challengeResponse = try? jsonDecoder.decode(ChallengeResponse.self, from: data) {
                    completion(challengeResponse.data)
                }
            case .failure(let error):
                print("failure")
                print(error.localizedDescription)
            }
        }
    }
    static func createGroup(name: String, completion: @escaping (Group) -> Void) {
        let endpoint = "\(host)groups/"
        let parameters: [String:Any] = [
            "name": name
        ]
        print("making group")
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success group")
                let jsonDecoder = JSONDecoder()
                if let groupResponse = try? jsonDecoder.decode(GroupResponse.self, from: data) {
                    completion(groupResponse.data)
                }
            case .failure(let error):
                print("failure group")
                print(error.localizedDescription)
            }
        }
    }
    static func addPlayerToGroup(player_id: Int, group_id: Int, completion: @escaping (Group) -> Void) {
        let endpoint = "\(host)groups/assign_player_group/"
        let parameters: [String:Any] = [
            "player_id": player_id,
            "group_id": group_id
        ]
        print("adding to group")
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success groupadd")
                let jsonDecoder = JSONDecoder()
                if let groupResponse = try? jsonDecoder.decode(GroupResponse.self, from: data) {
                    completion(groupResponse.data)
                }
            case .failure(let error):
                print("failure groupadd")
                print(error.localizedDescription)
            }
        }
    }
    static func getGroup(name: String, completion: @escaping (Group) -> Void) {
        let endpoint = "\(host)groups/\(name)/"
        print("getting group")
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success group get")
                let jsonDecoder = JSONDecoder()
                if let groupResponse = try? jsonDecoder.decode(GroupResponse.self, from: data) {
                    completion(groupResponse.data)
                    print("in let group")
                }
                print("out let group")
            case .failure(let error):
                print("failure group get")
                print(error.localizedDescription)
            }
        }
    }
    static func updateProfilePicture(player_id: Int, image_data: String, completion: @escaping (Player) -> Void) {
        let endpoint = "\(host)players/update_profile_pic/"
        let parameters: [String:Any] = [
            "player_id": player_id,
            "image_data": image_data
        ]
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let playerResponse = try? jsonDecoder.decode(PlayerResponse.self, from: data) {
                    completion(playerResponse.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func deletePlayerFromGroup(group_id: Int, player_id: Int, completion: @escaping (Group) -> Void) {
        let endpoint = "\(host)groups/\(group_id)/\(player_id)/"
        let parameters = [
            "group_id": group_id,
            "player_id": player_id
        ]
        AF.request(endpoint, method: .delete, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let groupResponse = try? jsonDecoder.decode(GroupResponse.self, from: data){
                    completion(groupResponse.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func getGlobalLeaderboard(completion: @escaping ([[String]]) -> Void) {
        let endpoint = "\(host)leaderboard/"
        print("getting global")
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success global get")
                print(data)
                let jsonDecoder = JSONDecoder()
                if let leaderboardResponse = try? jsonDecoder.decode(LeaderboardResponse.self, from: data) {
                    completion(leaderboardResponse.data)
                    print("in global let")
                }
                print("out global let")
            case .failure(let error):
                print("failure global get")
                print(error.localizedDescription)
            }
        }
    }
    static func getGroupLeaderboard(group_id : Int, completion: @escaping ([[String]]) -> Void) {
        let endpoint = "\(host)leaderboard/\(group_id)/"
        print("getting group leader")
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success group leader")
                print(data)
                let jsonDecoder = JSONDecoder()
                if let leaderboardResponse = try? jsonDecoder.decode(LeaderboardResponse.self, from: data) {
                    completion(leaderboardResponse.data)
                    print("in group let")
                }
                print("out group let")
            case .failure(let error):
                print("failure group leader get")
                print(error.localizedDescription)
            }
        }
    }
    static func getGroupIdOfChallengeId(challenge_id : Int, completion: @escaping (ParameterOfGroup) -> Void) {
        let endpoint = "\(host)challenges/\(challenge_id)/group/"
        print("getting group id of challenge id")
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success gid cid")
                print(data)
                let jsonDecoder = JSONDecoder()
                if let leaderboardResponse = try? jsonDecoder.decode(ParameterOfGroupResponse.self, from: data) {
                    completion(leaderboardResponse.data)
                    print("in gid cid")
                }
                print("out gidcid")
            case .failure(let error):
                print("failure gidcid")
                print(error.localizedDescription)
            }
        }
    }
   
}
