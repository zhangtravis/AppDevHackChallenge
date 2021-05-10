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
//        let endpoint = "\(host)challenges/completed/"
        let endpoint = "\(host)challenges/completed/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let challengesResponse = try? jsonDecoder.decode(ChallengesResponse.self, from: data){
                    completion(challengesResponse.data)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func getAllUnclaimedChallenges(completion: @escaping ([Challenge]) -> Void) {
        let endpoint = "\(host)challenges/unclaimed/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let challengesResponse = try? jsonDecoder.decode(ChallengesResponse.self, from: data){
                    completion(challengesResponse.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func getAllCurrentChallenges(playerid: Int, completion: @escaping ([Challenge]) -> Void) {
        let endpoint = "\(host)players/\(playerid)/challenges/"
        print("getting all current challengers from player with id \(playerid)")
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("succ")
                let jsonDecoder = JSONDecoder()
                if let challengesResponse = try? jsonDecoder.decode(ChallengesResponse.self, from: data){
                    completion(challengesResponse.data)
                }
            case .failure(let error):
                print("fail")
                print(error.localizedDescription)
            }
        }
    }
    
    static func createChallenge(title: String, description: String, author_id: Int, username : String, group_id : String, completion: @escaping (Challenge) -> Void) {
        let endpoint = "\(host)challenges/"
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
                let jsonDecoder = JSONDecoder()
                if let challengeResponse = try? jsonDecoder.decode(ChallengeResponse.self, from: data) {
                    completion(challengeResponse.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func createPlayer(username: String, password: String, completion: @escaping (Player) -> Void) {
        let endpoint = "\(host)players/"
        let parameters: [String:Any] = [
            "username": username,
            "password": password

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
    static func getPlayerById(id: Int, completion: @escaping (Player) -> Void) {
        //        let endpoint = "\(host)challenges/completed/"
                print("\(id)")
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
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let challengeResponse = try? jsonDecoder.decode(ChallengeResponse.self, from: data) {
                    completion(challengeResponse.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
