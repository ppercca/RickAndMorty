//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 8/1/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit

class EpisodeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var episode: EpisodeResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEpisodeDetail()
        configureCollection()
    }

    fileprivate func loadEpisodeDetail() {
        imageView.image = UIImage(named: "\(episode.episode).png")
        nameLabel.text = episode.name
        episodeLabel.text = episode.episode
        airDateLabel.text = episode.air_date
    }
    
    func configureCollection() {
        flowLayout.minimumInteritemSpacing = 3.0
        flowLayout.minimumLineSpacing = 3.0
    }
    
}

extension EpisodeDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        var columns:CGFloat = 3.0
        if  width > height {
            columns = 5.0
        } else {
            columns = 3.0
        }
        let dimension = (width - ((columns - 1) * 3.0)) / columns
        return CGSize(width: dimension, height: dimension)
    }

}


extension EpisodeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episode.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
        cell.imageView.image = UIImage(named: "Placeholder")
        let characterURL = episode.characters[indexPath.row]
        RickAndMortyClient.getCharacter(id: nil, urlPath: characterURL, completion: { (characterResponse, error) in
            if let characterResponse = characterResponse {
                RickAndMortyClient.getImage(path: characterResponse.image) { (data, error) in
                    cell.imageView.image = UIImage(data: data!)
                }
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characterDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "CharacterDetailViewController") as! CharacterDetailViewController
        RickAndMortyClient.getCharacter(id: nil, urlPath: episode.characters[indexPath.row], completion: { (characterResponse, error) in
            if let characterResponse = characterResponse {
                characterDetailViewController.character = characterResponse
//                characterDetailViewController.modalPresentationStyle = .fullScreen
                self.present(characterDetailViewController, animated: true, completion: nil)
            }
        })
        
    }
    
}
