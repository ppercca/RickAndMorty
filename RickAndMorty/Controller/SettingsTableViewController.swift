//
//  SettingsTableViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 8/2/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableViewCell: UITableViewCell!
    @IBOutlet weak var darkAppereanceLabel: UILabel!
    @IBOutlet weak var switchValue: UISwitch!
    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkMode = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        switchValue.isOn = darkMode
        if darkMode {
            configureDarkMode()
        } else {
            configureLightMode()
        }
    }
    
    func configureDarkMode()  {
        tableView.backgroundColor = UIColor(named: "DarkBackground1")
        contentView.backgroundColor = UIColor(named: "DarkBackground2")
        darkAppereanceLabel.textColor = UIColor(named: "DarkValue")
        let header = tableView.headerView(forSection: 0)
        header?.tintColor = UIColor(named: "DarkBackground1")
        header?.textLabel?.textColor = UIColor(named: "DarkLabel")
        let footer = tableView.footerView(forSection: 0)
        footer?.tintColor = UIColor(named: "DarkBackground1")
     }
    
    func configureLightMode()  {
        tableView.backgroundColor = UIColor(named: "LightBackground1")
        contentView.backgroundColor = UIColor(named: "LightBackground2")
        darkAppereanceLabel.textColor = UIColor(named: "LightValue")
        let header = tableView.headerView(forSection: 0)
        header?.tintColor = UIColor(named: "LightBackground1")
        header?.textLabel?.textColor = UIColor(named: "LightLabel")
        let footer = tableView.footerView(forSection: 0)
        footer?.tintColor = UIColor(named: "LightBackground1")
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if darkMode {
            view.tintColor = UIColor(named: "DarkBackground1")
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor(named: "DarkLabel")
        } else {
            view.tintColor = UIColor(named: "LightBackground1")
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor(named: "LightLabel")
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if darkMode {
            view.tintColor = UIColor(named: "DarkBackground1")
        } else {
            view.tintColor = UIColor(named: "LightBackground1")
        }
    }
    
    @IBAction func swithMode(_ sender: Any) {
        if switchValue.isOn {
            UserDefaults.standard.set(true, forKey: "isDarkModeEnabled")
            configureDarkMode()
        } else {
            UserDefaults.standard.set(false, forKey: "isDarkModeEnabled")
            configureLightMode()
        }
    }
    
}
