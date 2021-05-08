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
                if let postResponse = try? jsonDecoder.decode(ChallengesResponse.self, from: data){
                    completion(postResponse.data)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
