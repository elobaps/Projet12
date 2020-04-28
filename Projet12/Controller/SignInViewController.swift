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
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    
    private let authService: AuthService = AuthService()
    weak var delegate: AuthenticationDataPassingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction private func signInButtonTapped(_ sender: Any) {
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
    
    @IBAction private func resetPasswordButtonTapped(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Mot de passe oublié?", message: "Entrez votre email", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Votre email"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Annulé", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Validé", style: .default, handler: { (_) in
            guard let resetEmail = forgotPasswordAlert.textFields?.first?.text else { return }
            self.authService.resetPassword(email: resetEmail, completion: { (isSuccess) in
                DispatchQueue.main.async {
                    if !isSuccess {
                        let resetFailedAlert = UIAlertController(title: "Erreur", message: "Vérifier votre adresse email", preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    } else {
                        let resetEmailSentAlert = UIAlertController(title: "OK", message: "Un email vient de vous être envoyé", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @IBAction private func unwindToSignInViewController(_ segue: UIStoryboardSegue) {
        guard let signUpViewController = segue.source as? SignUpViewController else { return }
        dismiss(animated: true) {
            self.delegate?.authenticationSucceded(with: signUpViewController.userNavigation)
        }
    }
}
