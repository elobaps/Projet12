//
//  FamilyHomeViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 18/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class FamilyHomeViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var navSecondView: UIView!
    @IBOutlet private weak var quoteLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    // MARK: - Properties
    
    private let authService = AuthService()
    private let userService: UserService = UserService()
    private var quote: QuoteData?
    private let quoteService = QuoteService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        loadedUserData()
        quoteData()
        navSecondView.configureNavSecondView()
    }
    
    // MARK: - Action
    
    @IBAction private func logOutButtonTapped(_ sender: Any) {
        authService.signOut { (isSucceded) in
            if isSucceded {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.presentAlert(titre: "Erreur", message: "La déconnexion a échoué")
            }
        }
    }
    
    // MARK: - Method
    
    private func loadedUserData() {
        guard let uid = authService.currentUID else { return }
        userService.getUserData(with: uid) { (result) in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self.navigationItem.title = "Bonjour \(userData[0].firstName)"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(titre: "Erreur", message: "Le chargement des informations a échoué")
                    print(error)
                }
            }
        }
    }
    
    /// method that manages the data of the network call
    private func quoteData() {
        quoteService.getQuote { result in
            switch result {
            case .success(let quoteData):
                DispatchQueue.main.sync {
                    self.updateQuote(data: quoteData)
                }
            case .failure(let error):
                DispatchQueue.main.sync {
                    self.presentAlert(titre: "Error", message: "Service non disponible")
                    print(error)
                }
            }
        }
    }
    
    private func updateQuote(data: QuoteData) {
        quoteLabel.text = data.quoteText
        authorLabel.text = data.quoteAuthor
    }
}
