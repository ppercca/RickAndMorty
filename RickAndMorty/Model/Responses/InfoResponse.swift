//
//  InfoResponse.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/29/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

struct InfoResponse: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
