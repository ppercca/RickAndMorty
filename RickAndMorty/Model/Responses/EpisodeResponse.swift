//
//  EpisodeResponse.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/29/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

struct EpisodeResponse: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    var charactersData: [Data]?
    let url: String
    let created: String
}
