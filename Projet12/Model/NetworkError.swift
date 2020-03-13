//
//  NetworkError.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 11/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

/// Enum for network call's error
enum NetworkError: Error {
    case domainError
    case invalidData
    case networkError
}
