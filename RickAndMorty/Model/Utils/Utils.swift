//
//  Utils.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/31/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

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
    
}
