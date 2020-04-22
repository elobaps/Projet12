//
//  profilViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 22/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    
    private let reportService: ReportService = ReportService()
    private let authService: AuthService = AuthService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedUserData()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let userFirstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let userLastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        reportService.updateUserInformations(userFirstName: userFirstName, userLastName: userLastName, email: email, password: password) { (isSuccess) in
            if isSuccess {
                self.presentAlert(titre: "Enregistré", message: "Vos informations ont été mis à jour")
            } else {
                self.presentAlert(titre: "Erreur", message: "L'enregistrement de vos informations a échoué")
            }
        }
    }
    
    @IBAction func deletedAccountButtonTapped(_ sender: Any) {
        presentAlertVerification(titre: "Attention", message: "Etes vous sur de vouloir supprimer votre compte ?") { (success) in
            guard success == true else { return }
            self.reportService.deleteAccount { (isSuccess) in
                if !isSuccess {
                    self.presentAlert(titre: "Erreur", message: "La suppression du compte a échoué")
                }
            }
            self.reportService.deletedUser { (isSuccess) in
                if !isSuccess {
                    self.presentAlert(titre: "Erreur", message: "La suppression du document a échoué")
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    // MARK: - Method
    
    func loadedUserData() {
        guard let uid = authService.currentUID else { return }
        reportService.getUserData(with: uid) { (result) in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self.firstNameTextField.text = userData[0].firstName
                    self.lastNameTextField.text = userData[0].lastName
                    self.emailTextField.text = userData[0].email
                    self.passwordTextField.text = userData[0].password
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des informations a échoué")
                print(error)
            }
        }
    }
}
