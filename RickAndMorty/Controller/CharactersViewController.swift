//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/29/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit

func statusIcon(status: String) -> String {
        switch status {
        case "Alive":
            return "🟢"
        case "Dead":
            return "🔴"
        default:
            return "⚪"
    }
}

class CharactersViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RickAndMortyClient.getCharacters(page: page, completion: handleGetCharactersResponse(charactersResponse:error:))
    }
    
    func handleGetCharactersResponse(charactersResponse: CharactersResponse?, error: Error?) {
        RickAndMortyModel.characters = charactersResponse
        tableView.reloadData()
    }
    
}

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RickAndMortyModel.characters?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell") as! CharacterTableViewCell
        if let character = RickAndMortyModel.characters?.results[indexPath.row] {
            RickAndMortyClient.getImage(path: character.image) { (data, error) in
                cell.characterImageView.image = UIImage(data: data!)

            }
            cell.nameLabel.text = character.name
            cell.statusLabel.text = "\(statusIcon(status: character.status)) \(character.status) - \(character.species)"
            cell.lastKnownLocationLabel.text = character.location.name
            RickAndMortyClient.getEpisode(id: nil, urlPath: character.episode[0]) { (edpisodeResponse, error) in
                if let edpisodeResponse = edpisodeResponse {
                    cell.firstSeenLocationLabel.text = edpisodeResponse.name
                }
            }
        }
        return cell
    }
    
    
}
