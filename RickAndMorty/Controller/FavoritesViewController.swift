//
//  FavoritesViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 8/4/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FavoritesViewController: UIViewController {
    @IBOutlet weak var charactersTableView: UITableView!
    @IBOutlet weak var episodesTableView: UITableView!
    @IBOutlet weak var favoriteCharactersLabel: UILabel!
    @IBOutlet weak var favoriteEpisodesLabel: UILabel!
    @IBOutlet weak var favoriteCharactersActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteEpisodesActivityIndicator: UIActivityIndicatorView!
    var darkMode: Bool = false
    var authenticatedEmail: String!
    var charactersCollectionReference : CollectionReference!
    var episodesCollectionReference: CollectionReference!
    var favoriteCharacters: [CharacterResponse] = []
    var favoriteEpisodes: [EpisodeResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDatabase()
        navigationController?.setToolbarHidden(true, animated: false)
        darkMode = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        if darkMode {
            configureDarkMode()
            charactersTableView.reloadData()
            episodesTableView.reloadData()
        } else {
            configureLightMode()
            charactersTableView.reloadData()
            episodesTableView.reloadData()
        }
    }
    
    // MARK: - Firestore Method to retrieve Favorite Characters and Episodes
    
    func configureDatabase() {
        favoriteCharactersActivityIndicator.startAnimating()
        favoriteEpisodesActivityIndicator.startAnimating()
        if let authenticatedEmail = UserDefaults.standard.string(forKey: "EmailAuthenticated") {
            print("Authenticated User: \(authenticatedEmail)")
            favoriteCharacters = []
            favoriteEpisodes = []
            charactersCollectionReference = Firestore.firestore().collection("\(authenticatedEmail)-favoriteCaracters")
            charactersCollectionReference.getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    self.favoriteCharactersActivityIndicator.stopAnimating()
                    for document in snapshot.documents {
                        print("\(document.documentID) => \(document.data())")
                        let characterResponse = CharacterResponse(
                            id: document.data()["id"] as! Int,
                            name: document.data()["name"] as! String,
                            status: document.data()["status"] as! String,
                            species: document.data()["species"] as! String,
                            type: document.data()["type"] as! String,
                            gender: document.data()["gender"] as! String,
                            origin: nil,
                            location: LocationResponse(id: nil, name: (document.data()["locationName"] as? String)!, type: nil, dimension: nil, residents: nil, url: "", created: nil),
                            locationName: document.data()["locationName"] as? String,
                            image: document.data()["image"] as! String,
                            imageData: nil,
                            episode: document.data()["episode"] as! [String],
                            episodePath: document.data()["episodePath"] as? String,
                            url: document.data()["url"] as! String,
                            created: document.data()["created"] as! String)
                        self.favoriteCharacters.append(characterResponse)
                        self.charactersTableView.reloadData()
                    }
                } else {
                    print("Document does not exist")
                }
            }
            episodesCollectionReference = Firestore.firestore().collection("\(authenticatedEmail)-favoriteEpisodes")
            episodesCollectionReference.getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    self.favoriteEpisodesActivityIndicator.stopAnimating()
                    for document in snapshot.documents {
                        let episodeResponse = EpisodeResponse(
                            id: document.data()["id"] as! Int,
                            name: document.data()["name"] as! String,
                            air_date: document.data()["airDate"] as! String,
                            episode: document.data()["episode"] as! String,
                            characters: document.data()["characters"] as! [String],
                            charactersData: nil,
                            url: document.data()["url"] as! String,
                            created: document.data()["created"] as! String)
                        self.favoriteEpisodes.append(episodeResponse)
                        self.episodesTableView.reloadData()
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
}

// MARK: - Table Views Methods

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return favoriteCharacters.count
        } else {
            return favoriteEpisodes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView.tag \(tableView.tag)")
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell") as! CharacterTableViewCell
            if darkMode {
                configureCellDarkMode(cell: cell)
            } else {
                configureCellLightMode(cell: cell)
            }
            RickAndMortyClient.getImage(urlString: favoriteCharacters[indexPath.row].image, index: indexPath.row) { (image, error, index) in
                cell.characterImageView.image = image
            }
            cell.nameLabel.text = favoriteCharacters[indexPath.row].name
            cell.statusLabel.text = "\(Utils.statusIcon(status: favoriteCharacters[indexPath.row].status)) \(favoriteCharacters[indexPath.row].status) - \(favoriteCharacters[indexPath.row].species)"
            cell.lastKnownLocationLabel.text = favoriteCharacters[indexPath.row].locationName
            
            RickAndMortyClient.getEpisode(id: nil, urlPath: favoriteCharacters[indexPath.row].episodePath) { (edpisodeResponse, error) in
                if let edpisodeResponse = edpisodeResponse {
                    cell.firstSeenLocationLabel.text = edpisodeResponse.name
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell") as! EpisodeTableViewCell
            if darkMode {
                configureCellDarkMode(cell: cell)
            } else {
                configureCellLightMode(cell: cell)
            }
            cell.episodeImageView.image = UIImage(named: "\(favoriteEpisodes[indexPath.row].episode)")
            cell.nameLabel.text = favoriteEpisodes[indexPath.row].name
            cell.episodeLabel.text = favoriteEpisodes[indexPath.row].episode
            cell.airDateLabel.text = favoriteEpisodes[indexPath.row].air_date
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            let characterDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "CharacterDetailViewController") as! CharacterDetailViewController
            characterDetailViewController.character = favoriteCharacters[indexPath.row]
            self.navigationController?.pushViewController(characterDetailViewController, animated: true)
        } else {
            let episodeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "EpisodeDetailViewController") as! EpisodeDetailViewController
            episodeDetailViewController.episode = favoriteEpisodes[indexPath.row]
            self.navigationController?.pushViewController(episodeDetailViewController, animated: true)
        }
    }
    
}

// MARK: - Dark and Light Mode Methods

extension FavoritesViewController {
    
    func configureDarkMode() {
        view.backgroundColor = UIColor(named: "DarkBackground1")
        charactersTableView.backgroundColor = UIColor(named: "DarkBackground1")
        episodesTableView.backgroundColor = UIColor(named: "DarkBackground1")
        favoriteCharactersLabel.textColor = UIColor(named: "DarkValue")
        favoriteEpisodesLabel.textColor = UIColor(named: "DarkValue")
    }
    
    func configureLightMode() {
        view.backgroundColor = UIColor(named: "LightBackground1")
        charactersTableView.backgroundColor = UIColor(named: "LightBackground1")
        episodesTableView.backgroundColor = UIColor(named: "LightBackground1")
        favoriteCharactersLabel.textColor = UIColor(named: "LightValue")
        favoriteEpisodesLabel.textColor = UIColor(named: "LightValue")
    }
    
    func configureTableCellDarkMode(cell: UITableViewCell, tag: Int) {
        if tag == 1 {
            configureCellDarkMode(cell: cell as! CharacterTableViewCell)
        } else {
            configureCellDarkMode(cell: cell as! EpisodeTableViewCell)
        }
    }
    
    func configureTableCellLightMode(cell: UITableViewCell, tag: Int) {
        if tag == 1 {
            configureCellLightMode(cell: cell as! CharacterTableViewCell)
        } else {
            configureCellLightMode(cell: cell as! EpisodeTableViewCell)
        }
    }
    
    func configureCellDarkMode(cell: CharacterTableViewCell)  {
        cell.containerView.backgroundColor = UIColor(named: "DarkBackground1")
        cell.view.backgroundColor = UIColor(named: "DarkBackground2")
        cell.nameLabel.textColor = UIColor(named: "DarkValue")
        cell.statusLabel.textColor = UIColor(named: "DarkValue")
        cell.firstSeenLocationLabel.textColor = UIColor(named: "DarkValue")
        cell.lastKnownLocationLabel.textColor = UIColor(named: "DarkValue")
        cell.firstSeenIn.textColor = UIColor(named: "DarkLabel")
        cell.lastKnowLocation.textColor = UIColor(named: "DarkLabel")

    }
    
    func configureCellLightMode(cell: CharacterTableViewCell) {
        cell.containerView.backgroundColor = UIColor(named: "LightBackground1")
        cell.view.backgroundColor = UIColor(named: "LightBackground2")
        cell.nameLabel.textColor = UIColor(named: "LightValue")
        cell.statusLabel.textColor = UIColor(named: "LightValue")
        cell.firstSeenLocationLabel.textColor = UIColor(named: "LightValue")
        cell.lastKnownLocationLabel.textColor = UIColor(named: "LightValue")
        cell.firstSeenIn.textColor = UIColor(named: "LightLabel")
        cell.lastKnowLocation.textColor = UIColor(named: "LightLabel")
    }
    
    func configureCellDarkMode(cell: EpisodeTableViewCell)  {
        cell.containerView.backgroundColor = UIColor(named: "DarkBackground1")
        cell.view.backgroundColor = UIColor(named: "DarkBackground2")
        cell.nameLabel.textColor = UIColor(named: "DarkValue")
        cell.episodeLabel.textColor = UIColor(named: "DarkValue")
        cell.airDateLabel.textColor = UIColor(named: "DarkValue")
        cell.airDate.textColor = UIColor(named: "DarkLabel")
    }
    
    func configureCellLightMode(cell: EpisodeTableViewCell) {
        cell.containerView.backgroundColor = UIColor(named: "LightBackground1")
        cell.view.backgroundColor = UIColor(named: "LightBackground2")
        cell.nameLabel.textColor = UIColor(named: "LightValue")
        cell.episodeLabel.textColor = UIColor(named: "LightValue")
        cell.airDateLabel.textColor = UIColor(named: "LightValue")
        cell.airDate.textColor = UIColor(named: "LightLabel")
    }
    
}
