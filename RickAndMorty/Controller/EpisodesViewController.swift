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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var page: Int = 1
    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        RickAndMortyClient.getEpisodes(page: page, completion: handleGetEpisodesResponse(episodesResponse:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        darkMode = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        if darkMode {
            configureDarkMode()
            tableView.reloadData()
        } else {
            configureLightMode()
            tableView.reloadData()
        }
    }
    
    // MARK: - Load Episodes Methods
    
    func handleGetEpisodesResponse(episodesResponse: EpisodesResponse?, error: Error?) {
        activityIndicator.stopAnimating()
        if RickAndMortyModel.episodes == nil {
            RickAndMortyModel.episodes = episodesResponse
        } else {
            RickAndMortyModel.episodes?.results.append(contentsOf: episodesResponse!.results)
        }
        tableView.reloadData()
    }
}

// MARK: - Table View Methods for Episodes

extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
       
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RickAndMortyModel.episodes?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell") as! EpisodeTableViewCell
        if darkMode {
            configureCellDarkMode(cell: cell)
        } else {
            configureCellLightMode(cell: cell)
        }
        if let episode = RickAndMortyModel.episodes?.results[indexPath.row] {
            cell.episodeImageView.image = UIImage(named: "\(episode.episode)") // "\(episode.episode).png"
            cell.nameLabel.text = episode.name
            cell.episodeLabel.text = episode.episode
            cell.airDateLabel.text = episode.air_date
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = RickAndMortyModel.episodes?.results.count, let infoCount = RickAndMortyModel.episodes?.info.count else { return }
        if indexPath.row == count - 1 {
            if count < infoCount {
                page += 1
                activityIndicator.startAnimating()
                RickAndMortyClient.getEpisodes(page: page, completion: handleGetEpisodesResponse(episodesResponse:error:))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "EpisodeDetailViewController") as! EpisodeDetailViewController
        episodeDetailViewController.episode = RickAndMortyModel.episodes?.results[indexPath.row]
        self.navigationController?.pushViewController(episodeDetailViewController, animated: true)
    }
    
}

// MARK: - Dark and Light Mode Methods

extension EpisodesViewController {
    
    func configureDarkMode() {
        view.backgroundColor = UIColor(named: "DarkBackground1")
        tableView.backgroundColor = UIColor(named: "DarkBackground1")
    }
    
    func configureLightMode() {
        tableView.backgroundColor = UIColor(named: "LightBackground1")
        view.backgroundColor = UIColor(named: "LightBackground1")
    }
    
    func configureCellDarkMode(cell: EpisodeTableViewCell)  {
        cell.backgroundColor = UIColor(named: "DarkBackground1")
        cell.containerView.backgroundColor = UIColor(named: "DarkBackground1")
        cell.view.backgroundColor = UIColor(named: "DarkBackground2")
        cell.nameLabel.textColor = UIColor(named: "DarkValue")
        cell.episodeLabel.textColor = UIColor(named: "DarkValue")
        cell.airDateLabel.textColor = UIColor(named: "DarkValue")
        cell.airDate.textColor = UIColor(named: "DarkLabel")
    }
    
    func configureCellLightMode(cell: EpisodeTableViewCell) {
        cell.backgroundColor = UIColor(named: "LightBackground1")
        cell.containerView.backgroundColor = UIColor(named: "LightBackground1")
        cell.view.backgroundColor = UIColor(named: "LightBackground2")
        cell.nameLabel.textColor = UIColor(named: "LightValue")
        cell.episodeLabel.textColor = UIColor(named: "LightValue")
        cell.airDateLabel.textColor = UIColor(named: "LightValue")
        cell.airDate.textColor = UIColor(named: "LightLabel")
    }
    
}
