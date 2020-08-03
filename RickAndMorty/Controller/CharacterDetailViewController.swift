//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/31/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit

class CharacterDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lastKnowLocation: UILabel!
    @IBOutlet weak var lastKnownLocationLabel: UILabel!
    @IBOutlet weak var firstSeenIn: UILabel!
    @IBOutlet weak var firstSeenLocationLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    var character: CharacterResponse!
    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCharacterDetail()
        navigationController?.setToolbarHidden(true, animated: false)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        darkMode = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        if darkMode {
            configureDarkMode()
        } else {
            configureLightMode()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func loadCharacterDetail() {
        nameLabel.text = character.name
        statusLabel.text = "\(Utils.statusIcon(status: character.status)) \(character.status) - \(character.species)  \(Utils.genderIcon(gender: character.gender))"
        lastKnownLocationLabel.text = character.location.name
        RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[0]) { (edpisodeResponse, error) in
            if let edpisodeResponse = edpisodeResponse {
                self.firstSeenLocationLabel.text = edpisodeResponse.name
            }
        }
        RickAndMortyClient.getImage(path: character.image) { (data, error) in
            DispatchQueue.main.async {
                self.characterImageView.image = UIImage(data: data!)
            }
        }
    }
    
}

extension CharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character.episode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell")!
        if darkMode {
            configureCellDarkMode(cell: cell)
        } else {
            configureCellLightMode(cell: cell)
        }
        RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[indexPath.row]) { (episodeResponse, error) in
            if let episodeResponse = episodeResponse {
                cell.textLabel?.text = episodeResponse.name
                cell.detailTextLabel?.text = episodeResponse.air_date
                cell.imageView?.image = UIImage(named: "\(episodeResponse.episode)")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "EpisodeDetailViewController") as! EpisodeDetailViewController
        RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[indexPath.row], completion: { (episodeResponse, error) in
            if let episodeResponse = episodeResponse {
                episodeDetailViewController.episode = episodeResponse
                self.navigationController?.pushViewController(episodeDetailViewController, animated: true)
            }
        })
    }
    
}

extension CharacterDetailViewController {
    
    func configureDarkMode()  {
        view.backgroundColor = UIColor(named: "DarkBackground1")
        contentView.backgroundColor = UIColor(named: "DarkBackground2")
        nameLabel.textColor = UIColor(named: "DarkValue")
        statusLabel.textColor = UIColor(named: "DarkValue")
        firstSeenLocationLabel.textColor = UIColor(named: "DarkValue")
        lastKnownLocationLabel.textColor = UIColor(named: "DarkValue")
        firstSeenIn.textColor = UIColor(named: "DarkLabel")
        lastKnowLocation.textColor = UIColor(named: "DarkLabel")
        episodesLabel.textColor = UIColor(named: "DarkLabel")
        tableView.backgroundColor = UIColor(named: "DarkBackground2")
    }
    
    func configureLightMode() {
        view.backgroundColor = UIColor(named: "LightBackground1")
        contentView.backgroundColor = UIColor(named: "LightBackground2")
        nameLabel.textColor = UIColor(named: "LightValue")
        statusLabel.textColor = UIColor(named: "LightValue")
        firstSeenLocationLabel.textColor = UIColor(named: "LightValue")
        lastKnownLocationLabel.textColor = UIColor(named: "LightValue")
        firstSeenIn.textColor = UIColor(named: "LightLabel")
        lastKnowLocation.textColor = UIColor(named: "LightLabel")
        episodesLabel.textColor = UIColor(named: "LightLabel")
        tableView.backgroundColor = UIColor(named: "LightBackground2")
    }
    
    func configureCellDarkMode(cell: UITableViewCell)  {
        cell.contentView.backgroundColor = UIColor(named: "DarkBackground2")
        cell.textLabel?.textColor = UIColor(named: "DarkValue")
        cell.detailTextLabel?.textColor = UIColor(named: "DarkLabel")
    }
    
    func configureCellLightMode(cell: UITableViewCell) {
        cell.contentView.backgroundColor = UIColor(named: "LightBackground2")
        cell.textLabel?.textColor = UIColor(named: "LightValue")
        cell.detailTextLabel?.textColor = UIColor(named: "LightLabel")
    }
    
}
