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
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RickAndMortyClient.getCharacters(page: page, completion: handleGetCharactersResponse(charactersResponse:error:))
    }
    
    func handleGetCharactersResponse(charactersResponse: CharactersResponse?, error: Error?) {
        if RickAndMortyModel.characters == nil {
            RickAndMortyModel.characters = charactersResponse
        } else {
            RickAndMortyModel.characters?.results.append(contentsOf: charactersResponse!.results)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacterDetail" {
            let characterDetailViewController = segue.destination as! CharacterDetailViewController
            characterDetailViewController.character = RickAndMortyModel.characters?.results[selectedIndex]
        }
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
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showCharacterDetail", sender: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
