//
//  PastChallenges.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//

import UIKit

struct Image: Codable {
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}

struct PastChallenge : Codable {
    var title: String
    var image: Image
    var description: String
    var sender: String
    var upvotes: Int
    var downvotes: Int
}
