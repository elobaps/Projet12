//
//  HomeViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 10/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var bordeauxTempLabel: UILabel!
    @IBOutlet private weak var bordeauxImageView: UIImageView!
    @IBOutlet private weak var bordeauxInfoLabel: UILabel!
    @IBOutlet private weak var quoteLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var uidPatientLabel: UILabel!
    @IBOutlet private weak var navSecondView: UIView!
    
    // MARK: - Properties
    
    private var city: WeatherData?
    private let weatherService = WeatherService()
    private var quote: QuoteData?
    private let quoteService = QuoteService()
    private let authService: AuthService = AuthService()
    private let userService: UserService = UserService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        loadedUserData()
        weatherData()
        quoteData()
        navSecondView.configureNavSecondView()
    }
    
    // MARK: - Actions
    
    @IBAction private func logOutButtonTapped(_ sender: Any) {
        authService.signOut { (isSucceded) in
            if isSucceded {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.presentAlert(titre: "Erreur", message: "La déconnexion a échoué")
            }
        }
    }
    
    // MARK: - Methods
    
    private func loadedUserData() {
        guard let uid = authService.currentUID else { return }
        userService.getUserData(with: uid) { (result) in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self.navigationItem.title = "Bonjour \(userData[0].firstName)"
                    self.uidPatientLabel.text = "N° \(uid)"
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des informations a échoué")
                print(error)
            }
        }
    }
    
    /// method that manages the data of the network call
    private func weatherData() {
        weatherService.getWeather { result in
            switch result {
            case .success(let weatherData):
                DispatchQueue.main.sync {
                    self.updateWeather(data: weatherData)
                }
            case .failure(let error):
                self.presentAlert(titre: "Error", message: "Service non disponible")
                print(error)
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
                self.presentAlert(titre: "Error", message: "Service non disponible")
                print(error)
            }
        }
    }
    
    private func updateWeather(data: WeatherData) {
        bordeauxTempLabel.text = String(data.main.temp.rounded()) + "°"
        bordeauxInfoLabel.text = data.weather[0].weatherDescription
        bordeauxImageView.image = UIImage(named: data.weather[0].icon ?? "09n")
    }
    
    private func updateQuote(data: QuoteData) {
        quoteLabel.text = data.quoteText
        authorLabel.text = data.quoteAuthor
    }
}
