//
//  FavoritesViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 8/4/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class FavoritesViewController: UIViewController {
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
//        self.ref.child("users").child(user.uid).setValue(["username": username])

    }
    
}
