//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/30/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit

class EpisodesViewController: UITableViewController {

    var page: Int = 1
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RickAndMortyClient.getEpisodes(page: page, completion: handleGetEpisodesResponse(episodesResponse:error:))
    }
    
    func handleGetEpisodesResponse(episodesResponse: EpisodesResponse?, error: Error?) {
        if RickAndMortyModel.episodes == nil {
            RickAndMortyModel.episodes = episodesResponse
        } else {
            RickAndMortyModel.episodes?.results.append(contentsOf: episodesResponse!.results)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEpisodeDetail" {
            let episodeDetailViewController = segue.destination as! EpisodeDetailViewController
            episodeDetailViewController.episode = RickAndMortyModel.episodes?.results[selectedIndex]
        }
    }
       
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RickAndMortyModel.episodes?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell") as! EpisodeTableViewCell
        if let episode = RickAndMortyModel.episodes?.results[indexPath.row] {
            cell.episodeImageView.image = UIImage(named: "\(episode.episode).png")
            cell.nameLabel.text = episode.name
            cell.episodeLabel.text = episode.episode
            cell.airDateLabel.text = episode.air_date
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = RickAndMortyModel.episodes?.results.count, let infoCount = RickAndMortyModel.episodes?.info.count else { return }
        if indexPath.row == count - 1 {
            if count < infoCount {
                page += 1
                RickAndMortyClient.getEpisodes(page: page, completion: handleGetEpisodesResponse(episodesResponse:error:))
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showEpisodeDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
