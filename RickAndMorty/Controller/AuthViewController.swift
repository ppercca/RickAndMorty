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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    // MARK: - Sign In Methods with Firebase with Email/Password, Google and Facebook
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        setLogginIn(true)
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                self.proceedAuthenticated(authDataResult: authDataResult, error: error, provider: Utils.ProviderType.basic.rawValue)
            }
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        setLogginIn(true)
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
                self.proceedAuthenticated(authDataResult: authDataResult, error: error, provider: Utils.ProviderType.basic.rawValue)
            }
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        setLogginIn(true)
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        setLogginIn(true)
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            switch result {
            case .success(granted: _, declined: _, token: let token):
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
        setLogginIn(true)
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
            setLogginIn(false)
        }
    }
    
    private func authenticated(){
        setLogginIn(true)
        let tabViewController = storyboard?.instantiateViewController(identifier: "UITabBarController")  as! UITabBarController
        tabViewController.modalPresentationStyle = .fullScreen
        tabViewController.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.setLogginIn(false)
            self.present(tabViewController, animated: false, completion: nil)
        }
    }
    
    func setLogginIn(_ logginIn: Bool) {
        if logginIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !logginIn
        passwordTextField.isEnabled = !logginIn
        signInButton.isEnabled = !logginIn
        signUpButton.isEnabled = !logginIn
        googleButton.isEnabled = !logginIn
        facebookButton.isEnabled = !logginIn
    }
    
}

extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        setLogginIn(false)
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                self.proceedAuthenticated(authDataResult: authDataResult, error: error, provider: Utils.ProviderType.google.rawValue)
            }
        }
    }
    
}
