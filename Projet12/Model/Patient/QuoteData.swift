//
//  QuoteData.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 11/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

// MARK: - Quote Structure

struct QuoteData: Decodable {
    let quoteText, quoteAuthor: String
}
