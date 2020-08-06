//
//  Utils.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/31/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    enum ProviderType: String {
        case basic
        case google
        case facebook
    }

    class func statusIcon(status: String) -> String {
            switch status {
            case "Alive":
                return "🟢"
            case "Dead":
                return "🔴"
            default:
                return "⚪"
        }
    }
    
    class func genderIcon(gender: String) -> String {
            switch gender {
            case "Male":
                return "- ♂️"
            case "Female":
                return "- ♀️"
            default:
                return ""
        }
    }
    
    class func generateKey(url: String) -> String{
        let splitedURL = url.split(separator: "/")
        return "\(splitedURL[splitedURL.count - 2])_\(splitedURL[splitedURL.count - 1].replacingOccurrences(of: ".jpeg", with: ""))"
    }
    
    class func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    class func storeImage(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.pngData() {
            if let filePath = filePath(forKey: key) {
                do  {
                    try pngRepresentation.write(to: filePath, options: .atomic)
                    print("Storing --> \(key)")
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
    
    class func retrieveImage(forKey key: String) -> UIImage? {
        if let filePath = filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            print("Retrieving --> \(key)")
            return image
        }
        return nil
    }

}
