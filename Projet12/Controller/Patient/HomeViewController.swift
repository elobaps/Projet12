//
//  ViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 10/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var bordeauxTempLabel: UILabel!
    @IBOutlet weak private var bordeauxImageView: UIImageView!
    @IBOutlet weak private var bordeauxInfoLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - Properties
    
    private var city: WeatherData?
    private let weatherService = WeatherService()
    private var quote: QuoteData?
    private let quoteService = QuoteService()
    private let authService: AuthService = AuthService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        weatherData()
        quoteData()
    }
    
    // MARK: - Actions
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        authService.signOut { (isSucceded) in
            if isSucceded {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.presentAlert(titre: "Erreur", message: "La déconnexion a échoué")
            }
        }
    }
    
    // MARK: - Methods
    
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
