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
    }
    
}
