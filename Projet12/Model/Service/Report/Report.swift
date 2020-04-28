//
//  Report.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

struct Report: Equatable {
    
    var fromUid: String?
    var identifier: String?
    var title: String?
    var text: String?
    var published: Bool?
    var timestamp: Double?
    var forUid: String?
    
    init(dictionnary: [String: Any]) {
        fromUid = dictionnary[Constants.FStore.userUID] as? String
        identifier = dictionnary[Constants.FStore.reportIdentifier] as? String
        title = dictionnary[Constants.FStore.titleReport] as? String
        text = dictionnary[Constants.FStore.textReport] as? String
        published = dictionnary[Constants.FStore.publishedReport] as? Bool
        timestamp = dictionnary[Constants.FStore.timestampReport] as? Double
        forUid = dictionnary[Constants.FStore.reportForUid] as? String
    }
}
