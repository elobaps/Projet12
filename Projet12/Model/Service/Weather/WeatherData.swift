//
//  WeatherData.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 11/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

// MARK: - Weather Structure

struct WeatherData: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
    let cod: Int
}

// MARK: - Main
struct Main: Decodable {
    let temp: Double
}

// MARK: - Weather
struct Weather: Decodable {
    let weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}
