//
//  AuthViewController.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 8/3/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class AuthViewController: UIViewController {
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: "EmailAuthenticated"), let provider = defaults.string(forKey: "AuthenticatorProvider") {
            print("user: \(email)  provider: \(provider)")
            authenticated()
        }
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if let email = emailTextView.text, let password = passwordTextView.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                self.proceedAuthenticated(authDataResult: authDataResult, error: error, provider: Utils.ProviderType.basic.rawValue)
            }
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        if let email = emailTextView.text, let password = passwordTextView.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
                self.proceedAuthenticated(authDataResult: authDataResult, error: error, provider: Utils.ProviderType.basic.rawValue)
            }
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            switch result {
            case .success(granted: let granted, declined: let declined, token: let token):
                let authCredential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                Auth.auth().signIn(with: authCredential) { (authDataResult, error) in
                    self.proceedAuthenticated(authDataResult: authDataResult, error: error, provider: Utils.ProviderType.facebook.rawValue)
                }
            case .failed(_):
                break
            case .cancelled:
                break
            }
            
        }
    }
    
    private func proceedAuthenticated(authDataResult: AuthDataResult?, error: Error?, provider: String) {
        if let authDataResult = authDataResult, error == nil {
            print("user: \(String(describing: authDataResult.user.email))")
            UserDefaults.standard.set(authDataResult.user.email, forKey: "EmailAuthenticated")
            UserDefaults.standard.set(provider, forKey: "AuthenticatorProvider")
            UserDefaults.standard.synchronize()
            authenticated()
        } else {
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func authenticated(){
        let tabViewController = storyboard?.instantiateViewController(identifier: "UITabBarController")  as! UITabBarController
        tabViewController.modalPresentationStyle = .fullScreen
        tabViewController.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(tabViewController, animated: false, completion: nil)
        }
    }
    
}

extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                self.proceedAuthenticated(authDataResult: authDataResult, error: error, provider: Utils.ProviderType.google.rawValue)
            }
        }
    }
    
}
