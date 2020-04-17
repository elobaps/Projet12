//
//  SignInViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 13/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    
    private let authService: AuthService = AuthService()
    weak var delegate: AuthenticationDataPassingDelegate?
    
    override func viewDidLoad() {
          super.viewDidLoad()
          configureNavigationBar()
      }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let userNavigation = UserNavigation.allCases[segmentedControl.selectedSegmentIndex]
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        authService.signIn(type: userNavigation.rawValue, email: email, password: password) { (isSucceded) in
            if isSucceded {
                self.dismiss(animated: true) {
                    self.delegate?.authenticationSucceded(with: userNavigation)
                }
            } else {
                self.presentAlert(titre: "Erreur", message: "La connexion a échoué")
            }
        }
    }
    
    @IBAction private func unwindToSignInViewController(_ segue: UIStoryboardSegue) {
        guard let signUpViewController = segue.source as? SignUpViewController else { return }
        dismiss(animated: true) {
            self.delegate?.authenticationSucceded(with: signUpViewController.userNavigation)
        }
    }
}
