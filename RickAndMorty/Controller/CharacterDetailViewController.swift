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
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lastKnownLocationLabel: UILabel!
    @IBOutlet weak var firstSeenLocationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var character: CharacterResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCharacterDetail()
        navigationController?.setToolbarHidden(true, animated: false)
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
            self.characterImageView.image = UIImage(data: data!)
        }
    }
    
}

extension CharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character.episode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell")!
        RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[indexPath.row]) { (episodeResponse, error) in
            if let episodeResponse = episodeResponse {
                cell.textLabel?.text = episodeResponse.name
                cell.detailTextLabel?.text = episodeResponse.air_date
//                cell.imageView?.image = UIImage(named: "\(episodeResponse.episode).png")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "EpisodeDetailViewController") as! EpisodeDetailViewController
                RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[indexPath.row], completion: { (episodeResponse, error) in
                    if let episodeResponse = episodeResponse {
                        episodeDetailViewController.episode = episodeResponse
        //                characterDetailViewController.modalPresentationStyle = .fullScreen
                        self.present(episodeDetailViewController, animated: true, completion: nil)
                    }
                })
    }
    
}
