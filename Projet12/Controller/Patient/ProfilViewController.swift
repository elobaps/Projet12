//
//  profilViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 22/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class ProfilViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var navSecondView: UIView!
    
    // MARK: - Properties
    
    private let userService: UserService = UserService()
    private let authService: AuthService = AuthService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        navSecondView.configureNavSecondView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedUserData()
    }
    
    // MARK: - Actions
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        guard let userFirstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let userLastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        userService.updateUserInformations(userFirstName: userFirstName, userLastName: userLastName, email: email) { (isSuccess) in
            if isSuccess {
                self.presentAlert(titre: "Enregistré", message: "Vos informations ont été mis à jour")
            } else {
                self.presentAlert(titre: "Erreur", message: "L'enregistrement de vos informations a échoué")
            }
        }
    }
    
    @IBAction private func deletedAccountButtonTapped(_ sender: Any) {
        presentAlertVerification(titre: "Attention", message: "Etes vous sur de vouloir supprimer votre compte ?") { (success) in
            guard success == true else { return }
            self.userService.deleteAccount { (isSuccess) in
                if !isSuccess {
                    self.presentAlert(titre: "Erreur", message: "La suppression du compte a échoué")
                }
            }
            self.userService.deletedUserData { (isSuccess) in
                if !isSuccess {
                    self.presentAlert(titre: "Erreur", message: "La suppression du document a échoué")
                }
            }
            self.authService.signOut { _ in }
        }
    }
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    // MARK: - Method
    
    private func loadedUserData() {
        guard let uid = authService.currentUID else { return }
        userService.getUserData(with: uid) { (result) in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self.firstNameTextField.text = userData[0].firstName
                    self.lastNameTextField.text = userData[0].lastName
                    self.emailTextField.text = userData[0].email
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des informations a échoué")
                print(error)
            }
        }
    }
}
