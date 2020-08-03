//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/29/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lastKnownLocationLabel: UILabel!
    @IBOutlet weak var firstSeenLocationLabel: UILabel!
    @IBOutlet weak var lastKnowLocation: UILabel!
    @IBOutlet weak var firstSeenIn: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }

}
