//
//  SettingsTableViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 8/2/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var contentView1: UIView!
    @IBOutlet weak var contentView2: UIView!
    @IBOutlet weak var tableViewCell: UITableViewCell!
    @IBOutlet weak var darkAppereanceLabel: UILabel!
    @IBOutlet weak var closeSessionButton: UIButton!
    @IBOutlet weak var switchValue: UISwitch!
    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        darkMode = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        switchValue.isOn = darkMode
        if darkMode {
            configureDarkMode()
        } else {
            configureLightMode()
        }
    }
    
    @IBAction func closeSessionButtonTapped(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Sign Out", message: "Are you sure that you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let provider = UserDefaults.standard.string(forKey: "AuthenticatorProvider")
              switch provider {
              case Utils.ProviderType.basic.rawValue:
                self.logOut()
              case Utils.ProviderType.google.rawValue:
                  GIDSignIn.sharedInstance()?.signOut()
                  self.logOut()
              case Utils.ProviderType.facebook.rawValue:
                  LoginManager().logOut()
                  self.logOut()
                  break
              default:
                  break
              }
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch  {
            //
        }
        UserDefaults.standard.removeObject(forKey: "AuthenticatorProvider")
        UserDefaults.standard.removeObject(forKey: "EmailAuthenticated")
        UserDefaults.standard.synchronize()
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.modalTransitionStyle = .crossDissolve
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func configureDarkMode()  {
        tableView.backgroundColor = UIColor(named: "DarkBackground1")
        contentView1.backgroundColor = UIColor(named: "DarkBackground2")
        contentView2.backgroundColor = UIColor(named: "DarkBackground2")
        darkAppereanceLabel.textColor = UIColor(named: "DarkValue")
        closeSessionButton.setTitleColor(UIColor(named: "DarkValue"), for: .normal)
        let header = tableView.headerView(forSection: 0)
        header?.tintColor = UIColor(named: "DarkBackground1")
        header?.textLabel?.textColor = UIColor(named: "DarkLabel")
        let footer = tableView.footerView(forSection: 0)
        footer?.tintColor = UIColor(named: "DarkBackground1")
     }
    
    func configureLightMode()  {
        tableView.backgroundColor = UIColor(named: "LightBackground1")
        contentView1.backgroundColor = UIColor(named: "LightBackground2")
        contentView2.backgroundColor = UIColor(named: "LightBackground2")
        darkAppereanceLabel.textColor = UIColor(named: "LightValue")
        closeSessionButton.setTitleColor(UIColor(named: "LightValue"), for: .normal)
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
        darkMode = switchValue.isOn
    }
    
}
