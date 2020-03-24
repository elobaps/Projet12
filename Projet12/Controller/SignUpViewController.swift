//
//  SignUpViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 13/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    
    private let authService: AuthService = AuthService()
    var userNavigation: UserNavigation = .none
    
    override func viewDidLoad() {
          super.viewDidLoad()
          configureNavigationBar()
      }
    
    // MARK: - Actions
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        userNavigation = UserNavigation.allCases[segmentedControl.selectedSegmentIndex]
        guard let userFirstName = userFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let userLastName = userLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        authService.signUp(type: userNavigation.rawValue, userFirstName: userFirstName, userLastName: userLastName, email: email, password: password) { (isSucceded) in
            if isSucceded {
                self.performSegue(withIdentifier: "unwindToSignInViewController", sender: nil)
            } else {
                self.presentAlert(titre: "Erreur", message: "Le mot de passe doit contenir au moins 6 caractères")
            }
        }
    }
}
