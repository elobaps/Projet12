//
//  UIViewController+Date.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 31/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Convert a timestamp into data then into String type 
   func convertTimestampToString(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedSring = dateFormatter.string(from: date)
        return formattedSring
    }
}
