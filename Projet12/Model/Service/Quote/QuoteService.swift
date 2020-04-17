//
//  QuoteService.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 11/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

final class QuoteService: EncoderUrl {

    // MARK: - Properties

    private var quoteSession: URLSession
    private var task: URLSessionDataTask?

    init(session: URLSession = URLSession(configuration: .default)) {
        quoteSession = session
    }

    // MARK: - Method

    /// network call
    func getQuote(callback: @escaping (Result<QuoteData, NetworkError>) -> Void) {
        guard let baseUrl = URL(string: "http://api.forismatic.com/api/1.0/") else { return }

        let parameters: [(String, String)] = [("method", "getQuote"), ("format", "json"), ("lang", "en")]
               let url = encode(baseUrl: baseUrl, parameters: parameters)

        task?.cancel()
        task = quoteSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    callback(.failure(.networkError))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(.networkError))
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(QuoteData.self, from: data) else {
                        callback(.failure(.invalidData))
                        return
                }
                callback(.success(responseJSON))
            }
            task?.resume()
        }
}
