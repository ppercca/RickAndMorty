//
//  CharacterResponse.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/29/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

struct CharacterResponse: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: OriginResponse?
    let location: LocationResponse?
    let locationName: String?
    var image: String
    var imageData: Data?
    let episode: [String]
    var episodePath: String?
    let url: String
    let created: String
}
