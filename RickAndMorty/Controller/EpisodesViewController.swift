//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/30/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit

class EpisodesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RickAndMortyClient.getEpisodes(page: page, completion: handleGetEpisodesResponse(episodesResponse:error:))
    }
    
    func handleGetEpisodesResponse(episodesResponse: EpisodesResponse?, error: Error?) {
        RickAndMortyModel.episodes = episodesResponse
        tableView.reloadData()
    }
    
}

extension EpisodesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RickAndMortyModel.episodes?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell") as! EpisodeTableViewCell
        if let episode = RickAndMortyModel.episodes?.results[indexPath.row] {
//            RickAndMortyClient.getImage(path: character.image) { (data, error) in
//                cell.characterImageView.image = UIImage(data: data!)
//
//            }
            cell.nameLabel.text = episode.name
//            cell.statusLabel.text = "\(statusIcon(status: character.status)) \(character.status) - \(character.species)"
//            cell.lastKnownLocationLabel.text = character.location.name
//            RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[0]) { (edpisodeResponse, error) in
//                if let edpisodeResponse = edpisodeResponse {
//                    cell.firstSeenLocationLabel.text = edpisodeResponse.name
//                }
//            }
        }
        return cell
    }
    
    
}
