//
//  FamilyHomeViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 18/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit
import Firebase

class FamilyHomeViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    
    private let authService = AuthService()
    private let reportService: ReportService = ReportService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        loadedUserData()
    }
    
    // MARK: - Action
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        authService.signOut { (isSucceded) in
            if isSucceded {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.presentAlert(titre: "Erreur", message: "La déconnexion a échoué")
            }
        }
    }
    
    // MARK: - Method
    
    func loadedUserData() {
        guard let uid = authService.currentUID else { return }
        reportService.getUserData(with: uid) { (result) in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    guard let userFirstName: String = userData[0].firstName as String? else { return }
                    self.navigationItem.title = "Bonjour \(userFirstName)"
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des informations a échoué")
                print(error)
            }
        }
    }
}
