//
//  Utility.swift
//  gdg
//
//  Created by Aaron on 6/8/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

/**
 get the current date as string format
 
 */
public func getCurrentDate(_ dateformat: String = "yyyy-MM-dd-HH-mm") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateformat
    let result = dateFormatter.string(from: Date())
    return result
}


public func downloadImage368(_ id: String, view: UIImageView, callback: @escaping (() -> Void)) {
    downloadImage(id, view: view, callback: callback, suffix: urlAvatarSuffix368)
}


public func downloadImage80(_ id: String, view: UIImageView, callback: @escaping (() -> Void)) {
    downloadImage(id, view: view, callback: callback, suffix: urlAvatarSuffix80)
}

private func downloadImage(_ id: String, view: UIImageView, callback: @escaping (() -> Void), suffix: String) {
    
    view.image = nil
    let url = URL(string: urlAvatarPrefix + id + ".jpg" + suffix)!
    getDataFromUrl(url) {(data, response, error) in
        
        DispatchQueue.main.async{ () -> Void in
            
            if data == nil || error != nil || data!.count < 100 {
                view.image = UIImage(named: "background_gdg_icon")!
                return
            }
            
            
            view.image = UIImage(data: data!)!
            callback()
        }
    }
    
}


public func circleImage(_ image: UIImage) -> UIImage {
    let square = CGSize(width: min(image.size.width, image.size.height), height: min(image.size.width, image.size.height))
    let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
    imageView.contentMode = .scaleAspectFill
    imageView.image = image
    imageView.layer.cornerRadius = square.width/2
    imageView.layer.masksToBounds = true
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    imageView.layer.render(in: context!)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}


/**
 async
 
 */
public func getDataFromUrl(_ url: URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)) {

    URLSession.shared.dataTask(with: url) { (data, response, error) in
        completion(data, response, error)
    }.resume()
    
    
//    URLSession.shared.dataTask(with: url, completionHandler: {
//        (data, response, error) in completion(data, response, error)
//        }) 
//        .resume()
}


func preCalculateTextHeight(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let label:UIVerticalAlignLabel = UIVerticalAlignLabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}


public func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
