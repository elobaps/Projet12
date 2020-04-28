//
//  Note.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

struct Note: Equatable {
    
    var fromUid: String?
    var identifier: String?
    var title: String?
    var text: String?
    var published: Bool?
    var timestamp: Double?
    var firstName: String?
    var lastName: String?
    
    init(dictionnary: [String: Any]) {
        fromUid = dictionnary[Constants.FStore.userUID] as? String
        identifier = dictionnary[Constants.FStore.identifier] as? String
        title = dictionnary[Constants.FStore.titleNote] as? String
        text = dictionnary[Constants.FStore.textNote] as? String
        published = dictionnary[Constants.FStore.publishedNote] as? Bool
        timestamp = dictionnary[Constants.FStore.timestamp] as? Double
        firstName = dictionnary[Constants.FStore.noteFirstName] as? String
        lastName = dictionnary[Constants.FStore.noteLastName] as? String
    }
}
