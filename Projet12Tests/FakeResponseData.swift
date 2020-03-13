//
//  FakeResponseData.swift
//  Projet12Tests
//
//  Created by Elodie-Anne Parquer on 11/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

final class FakeResponseData {
    
    // MARK: - Response
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                            statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.com/")!,
                                            statusCode: 500, httpVersion: nil, headerFields: nil)
    
    // MARK: - Error
    
    class WeatherError: Error {}
    static let errorWeather = WeatherError()
    
    class QuoteError: Error {}
    static let errorQuote = QuoteError()
    
    // MARK: - Data
    
    /// Weather
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        guard let data = try? Data(contentsOf: url!) else {
            fatalError("Weather.json can't be loaded !")
        }
        return data
    }
    
    /// Quote
    static var quoteCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Quote", withExtension: "json")
        guard let data = try? Data(contentsOf: url!) else {
            fatalError("Quote.json can't be loaded !")
        }
        return data
    }
   
    /// Incorrect Data
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
    
    /// Incorrect Data
    static let quoteIncorrectData = "erreur".data(using: .utf8)!
}
