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
        let endpoint = "\(host)challenges/"
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
    static func createChallenge(title: String, description: String, author_id: String, group_id : String, completion: @escaping (Challenge) -> Void) {
        let endpoint = "\(host)challenges/"
        let parameters: [String:Any] = [
            "title": title,
            "description": description,
            "author_id": author_id,
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
    
}
