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
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
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
}
