//
//  EpisodeTableViewCell.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/31/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit
class EpisodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDate: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        configureDarkMode()
        
    }
    
    func configureDarkMode()  {
        containerView.backgroundColor = UIColor(named: "PrimaryBackground1")
        view.backgroundColor = UIColor(named: "PrimaryBackground2")
        nameLabel.textColor = UIColor(named: "PrimaryLabelValue1")
        episodeLabel.textColor = UIColor(named: "PrimaryLabelValue1")
        airDateLabel.textColor = UIColor(named: "PrimaryLabelValue1")
        airDate.textColor = UIColor(named: "PrimaryLabel1")
    }
    
}
