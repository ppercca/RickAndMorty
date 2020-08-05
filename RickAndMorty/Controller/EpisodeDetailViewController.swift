//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 8/1/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EpisodeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDate: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var episodes: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var episode: EpisodeResponse!
    var darkMode: Bool = false
    var favorite: Bool = false
    var authenticatedEmail: String!
    var collectionReference : CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
        favoriteButton.tintColor = UIColor.gray
        loadEpisodeDetail()
        configureCollection()
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
        if let authenticatedEmail = UserDefaults.standard.string(forKey: "EmailAuthenticated") {
            collectionReference = Firestore.firestore().collection("\(authenticatedEmail)-favoriteEpisodes")
            collectionReference.document("\(episode.id)").getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    self.favorite = true
                    self.favoriteButton.tintColor = UIColor.yellow
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    fileprivate func loadEpisodeDetail() {
        imageView.image = UIImage(named: episode.episode)
        nameLabel.text = episode.name
        episodeLabel.text = episode.episode
        airDateLabel.text = episode.air_date
        if episode.charactersData == nil {
            episode.charactersData = []
        }
        for i in 0..<episode.characters.count {
            episode.charactersData?.append(UIImage(named: "Placeholder")!.pngData()!)
            RickAndMortyClient.getCharacter(id: nil, urlPath: episode.characters[i], index: i, completion: handleGetCharacterResponse(characterResponse:error:index:))
        }
    }
    
    func handleGetCharacterResponse(characterResponse: CharacterResponse?, error: Error?, index: Int?) {
        guard let characterResponse = characterResponse else { return }
        DispatchQueue.global(qos: .background).async { () -> Void in
            RickAndMortyClient.getImage(path: characterResponse.image, index: index!, completionHandler: self.handleImagesResponse(image:error:index:))
        }
    }
    
    func handleImagesResponse(image: UIImage? , error: Error?, index: Int) {
        if let image = image {
            episode.charactersData?[index] = image.jpegData(compressionQuality: 1.0)!
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureCollection() {
        flowLayout.minimumInteritemSpacing = 3.0
        flowLayout.minimumLineSpacing = 3.0
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if favorite {
            collectionReference.document("\(episode.id)").delete { (error) in
                self.favorite = false
                print("Removing: \(self.episode.id)")
                DispatchQueue.main.async {
                    self.favoriteButton.tintColor = UIColor.gray
                }
            }
        } else {
            collectionReference.document("\(episode.id)").setData(
                ["id": episode.id,
                "name": episode.name,
                "airDate": episode.air_date,
                "episode": episode.episode,
                "url": episode.url,
                "created": episode.created,
                ]) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Storing: \(self.episode.id)")
                    self.favorite = true
                    DispatchQueue.main.async {
                        self.favoriteButton.tintColor = UIColor.yellow
                    }
                }
            }
        }
    }
    
    
//    @objc func rotateScreen () {
//        var width = view.frame.size.width
//        var height = view.frame.size.height
//        if !(self.isViewLoaded && self.view.window != nil) {
//            width = view.frame.size.height
//            height = view.frame.size.width
//        }
//        orderCells(width: width, height: height)
//    }
    
//    func orderCells(width: CGFloat, height: CGFloat) {
//          let space:CGFloat = 3.0
//          var columns:CGFloat = 3.0
//          if  width > height {
//              columns = 5.0
//          } else {
//              columns = 3.0
//          }
//          let dimension = (width - ((columns - 1) * space)) / columns
//          flowLayout.itemSize = CGSize(width: dimension, height: dimension * 0.8)
//          flowLayout.minimumInteritemSpacing = space
//          flowLayout.minimumLineSpacing = space
//      }
}

extension EpisodeDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
//        let height = collectionView.frame.height
        let columns:CGFloat = 3.0
//        if  width > height {
//            columns = 5.0
//        } else {
//            columns = 3.0
//        }
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
        print("indexPath.row:  \(indexPath.row)")
        if let characterData = episode.charactersData?[indexPath.row] {
            cell.imageView.image = UIImage(data: characterData)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characterDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "CharacterDetailViewController") as! CharacterDetailViewController
        RickAndMortyClient.getCharacter(id: nil, urlPath: episode.characters[indexPath.row], index: nil, completion: { (characterResponse, error, nil) in
            if let characterResponse = characterResponse {
                characterDetailViewController.character = characterResponse
                self.navigationController?.pushViewController(characterDetailViewController, animated: true)
            }
        })
        
    }
    
}

extension EpisodeDetailViewController {
    
    func configureDarkMode()  {
        view.backgroundColor = UIColor(named: "DarkBackground1")
        contentView.backgroundColor = UIColor(named: "DarkBackground2")
        nameLabel.textColor = UIColor(named: "DarkValue")
        episodeLabel.textColor = UIColor(named: "DarkValue")
        airDateLabel.textColor = UIColor(named: "DarkValue")
        episodes.textColor = UIColor(named: "DarkLabel")
        airDate.textColor = UIColor(named: "DarkLabel")
        collectionView.backgroundColor = UIColor(named: "DarkBackground2")
    }
    
    func configureLightMode()  {
        view.backgroundColor = UIColor(named: "LightBackground1")
        contentView.backgroundColor = UIColor(named: "LightBackground2")
        nameLabel.textColor = UIColor(named: "LightValue")
        episodeLabel.textColor = UIColor(named: "LightValue")
        airDateLabel.textColor = UIColor(named: "LightValue")
        episodes.textColor = UIColor(named: "LightLabel")
        airDate.textColor = UIColor(named: "LightLabel")
        collectionView.backgroundColor = UIColor(named: "LightBackground2")
    }

}
