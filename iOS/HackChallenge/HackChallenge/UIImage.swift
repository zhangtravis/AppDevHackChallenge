//
//  UIImage.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/9/21.
//

import UIKit

extension UIImage {

    /// Return a resized image of targetSize
    func resize(toSize targetSize: CGSize) -> UIImage? {
        let horizontalRatio = targetSize.width / size.width
        let verticalRatio = targetSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
}
