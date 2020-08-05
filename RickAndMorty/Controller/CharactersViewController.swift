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
    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RickAndMortyClient.getCharacters(page: page, completion: handleGetCharactersResponse(charactersResponse:error:))
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
    
    func handleGetCharactersResponse(charactersResponse: CharactersResponse?, error: Error?) {
        guard var charactersResponse = charactersResponse else { return }
        for i in 0..<charactersResponse.results.count {
            charactersResponse.results[i].imageData = UIImage(named: "Placeholder")!.pngData()!
        }
        if RickAndMortyModel.characters == nil {
            RickAndMortyModel.characters = charactersResponse
        } else {
            RickAndMortyModel.characters?.results.append(contentsOf: charactersResponse.results)
        }
        DispatchQueue.global(qos: .background).async { () -> Void in
            self.loadImages(characters: charactersResponse.results, count: (RickAndMortyModel.characters?.results.count)!)
        }
    }
    
    func loadImages(characters: [CharacterResponse], count: Int){
        var i = 0
        for character in characters {
            RickAndMortyClient.getImage(path: character.image, index: (count - 20) + i, completionHandler: handleImagesResponse(image:error:index:))
            i += 1
        }
    }
    
    func handleImagesResponse(image: UIImage? , error: Error?, index: Int) {
        if let image = image {
            RickAndMortyModel.characters?.results[index].imageData = image.jpegData(compressionQuality: 1.0)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        if darkMode {
            configureCellDarkMode(cell: cell)
        } else {
            configureCellLightMode(cell: cell)
        }
        cell.characterImageView.image = UIImage(named: "Placeholder")
        if let character = RickAndMortyModel.characters?.results[indexPath.row] {
            cell.characterImageView.image = UIImage(data: character.imageData!)
            cell.nameLabel.text = character.name
            cell.statusLabel.text = "\(Utils.statusIcon(status: character.status)) \(character.status) - \(character.species)"
            cell.lastKnownLocationLabel.text = character.location?.name
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
        if indexPath.row == (count - 1) {
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

extension CharactersViewController {
    
    func configureDarkMode() {
        tableView.backgroundColor = UIColor(named: "DarkBackground1")
    }
    
    func configureLightMode() {
        tableView.backgroundColor = UIColor(named: "LightBackground1")
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
    
}
