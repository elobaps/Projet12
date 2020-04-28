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
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var userFirstNameTextField: UITextField!
    @IBOutlet private weak var userLastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var idPatientTextField: UITextField!
    
    // MARK: - Properties
    
    private let authService: AuthService = AuthService()
    var userNavigation: UserNavigation = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if segmentedControl.isEnabledForSegment(at: 0) {
            idPatientTextField.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userFirstNameTextField.resignFirstResponder()
        userLastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 2 {
            idPatientTextField.isHidden = false
        } else {
            idPatientTextField.isHidden = true
        }
    }
    
    @IBAction private func signUpButtonTapped(_ sender: Any) {
        userNavigation = UserNavigation.allCases[segmentedControl.selectedSegmentIndex]
        guard let userFirstName = userFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let userLastName = userLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let patientUid = idPatientTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if segmentedControl.selectedSegmentIndex == 2 {
            authService.signUpFamily(type: userNavigation.rawValue, userFirstName: userFirstName, userLastName: userLastName, email: email, password: password, patientUid: patientUid) { (isSucceded) in
                if isSucceded {
                    self.performSegue(withIdentifier: "unwindToSignInViewController", sender: nil)
                } else {
                    self.presentAlert(titre: "Erreur", message: "L'inscription a échoué")
                }
            }
        } else {
            authService.signUp(type: userNavigation.rawValue, userFirstName: userFirstName, userLastName: userLastName, email: email, password: password) { (isSucceded) in
                if isSucceded {
                    self.performSegue(withIdentifier: "unwindToSignInViewController", sender: nil)
                } else {
                    self.presentAlert(titre: "Erreur", message: "L'inscription a échoué'")
                }
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userFirstNameTextField:
            userLastNameTextField.becomeFirstResponder()
        case userLastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            idPatientTextField.becomeFirstResponder()
        default:
            idPatientTextField.resignFirstResponder()
        }
        return true
    }
}
