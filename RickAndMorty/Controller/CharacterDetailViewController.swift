//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/31/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit
import Firebase

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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var character: CharacterResponse!
    var darkMode: Bool = false
    var favorite: Bool = false
    var authenticatedEmail: String!
    var collectionReference : CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
        favoriteButton.tintColor = UIColor.gray
        loadCharacterDetail()
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
    
    func configureDatabase() {
        activityIndicator.startAnimating()
        if let authenticatedEmail = UserDefaults.standard.string(forKey: "EmailAuthenticated") {
            print("Authenticated User: \(authenticatedEmail)")
            collectionReference = Firestore.firestore().collection("\(authenticatedEmail)-favoriteCaracters")
            collectionReference.document("\(character.id)").getDocument { (document, error) in
                self.activityIndicator.stopAnimating()
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    self.favorite = true
                    self.favoriteButton.tintColor = UIColor(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    fileprivate func loadCharacterDetail() {
        nameLabel.text = character.name
        statusLabel.text = "\(Utils.statusIcon(status: character.status)) \(character.status) - \(character.species)  \(Utils.genderIcon(gender: character.gender))"
        lastKnownLocationLabel.text = character.location!.name
        RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[0]) { (edpisodeResponse, error) in
            if let edpisodeResponse = edpisodeResponse {
                self.firstSeenLocationLabel.text = edpisodeResponse.name
            }
        }
        RickAndMortyClient.getImage(path: character.image) { (data, error) in
            if let data = data {
                self.character.imageData = data
                DispatchQueue.main.async {
                    self.characterImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        self.activityIndicator.startAnimating()
        if favorite {
            collectionReference.document("\(character.id)").delete { (error) in
                self.favorite = false
                print("Removing: \(self.character.id)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.favoriteButton.tintColor = UIColor.gray
                }
            }
        } else {
            if let image = characterImageView.image {
                Utils.storeImage(image: image, forKey: "\(character.name)")
            }
            collectionReference.document("\(character.id)").setData(
                ["id": character.id,
                "name": character.name,
                "status": character.status,
                "species": character.species,
                "type": character.type,
                "gender": character.gender,
                "locationName": character.location!.name,
                "image": character.image,
                "episodePath": character.episode[0],
                "episode": character.episode,
                "url": character.url,
                "created": character.created,
                ]) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Storing: \(self.character.id)")
                    self.favorite = true
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.favoriteButton.tintColor = UIColor(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
                    }
                }
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
