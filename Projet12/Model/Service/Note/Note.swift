//
//  Note.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

struct Note: Equatable {
    
    var fromUid: String
    var identifier: String
    var title: String
    var text: String
    var published: Bool
    var timestamp: Double
}
