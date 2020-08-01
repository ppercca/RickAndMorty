//
//  EpisodeResponse.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/29/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

struct EpisodesResponse: Codable {
    let info: InfoResponse
    var results: [EpisodeResponse]
}
