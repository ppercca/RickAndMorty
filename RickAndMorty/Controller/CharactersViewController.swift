//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/29/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit

class CharactersViewController: UITableViewController {

    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        RickAndMortyClient.getCharacters(page: page, completion: handleGetCharactersResponse(charactersResponse:error:))
        if true { // UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
            tableView.backgroundColor = UIColor(named: "PrimaryBackground1")
        }
    }
    
    func handleGetCharactersResponse(charactersResponse: CharactersResponse?, error: Error?) {
        if RickAndMortyModel.characters == nil {
            RickAndMortyModel.characters = charactersResponse
        } else {
            RickAndMortyModel.characters?.results.append(contentsOf: charactersResponse!.results)
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RickAndMortyModel.characters?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell") as! CharacterTableViewCell
        if let character = RickAndMortyModel.characters?.results[indexPath.row] {
            RickAndMortyClient.getImage(path: character.image) { (data, error) in
                cell.characterImageView.image = UIImage(data: data!)

            }
            cell.nameLabel.text = character.name
            cell.statusLabel.text = "\(Utils.statusIcon(status: character.status)) \(character.status) - \(character.species)"
            cell.lastKnownLocationLabel.text = character.location.name
            RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[0]) { (edpisodeResponse, error) in
                if let edpisodeResponse = edpisodeResponse {
                    cell.firstSeenLocationLabel.text = edpisodeResponse.name
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = RickAndMortyModel.characters?.results.count, let infoCount = RickAndMortyModel.characters?.info.count else { return }
        if indexPath.row == count - 1 {
            if count < infoCount {
                page += 1
                RickAndMortyClient.getCharacters(page: page, completion: handleGetCharactersResponse(charactersResponse:error:))
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "CharacterDetailViewController") as! CharacterDetailViewController
        characterDetailViewController.character = RickAndMortyModel.characters?.results[indexPath.row]
        self.navigationController?.pushViewController(characterDetailViewController, animated: true)
    }
    
    
}
