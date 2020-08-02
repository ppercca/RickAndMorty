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
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    var character: CharacterResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCharacterDetail()
        navigationController?.setToolbarHidden(true, animated: false)
        configureDarkMode()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureDarkMode()  {
        view.backgroundColor = UIColor(named: "PrimaryBackground1")
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(named: "PrimaryBackground2")
        nameLabel.textColor = UIColor(named: "PrimaryLabelValue1")
        statusLabel.textColor = UIColor(named: "PrimaryLabelValue1")
        firstSeenLocationLabel.textColor = UIColor(named: "PrimaryLabelValue1")
        lastKnownLocationLabel.textColor = UIColor(named: "PrimaryLabelValue1")
        firstSeenIn.textColor = UIColor(named: "PrimaryLabel1")
        lastKnowLocation.textColor = UIColor(named: "PrimaryLabel1")
        episodesLabel.textColor = UIColor(named: "PrimaryLabel1")
        tableView.backgroundColor = UIColor(named: "PrimaryBackground2")
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
        if true {
            cell.backgroundColor = UIColor(named: "PrimaryBackground2")
            cell.textLabel?.textColor = UIColor(named: "PrimaryLabelValue1")
            cell.detailTextLabel?.textColor = UIColor(named: "PrimaryLabel1")
        }
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
                        self.navigationController?.pushViewController(episodeDetailViewController, animated: true)
                    }
                })
    }
    
}
