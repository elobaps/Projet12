//
//  NotePublishedTableViewCell.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 08/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class NotePublishedTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var note: Note? {
        didSet {
            nameLabel.text = "\(note?.firstName ?? "") \(note?.lastName ?? "")"
            let date = note?.timestamp
            dateLabel.text = convertTimestampToString(timestamp: date ?? 0)
        }
    }
    
    var report: Report? {
        didSet {
            let date = report?.timestamp
            dateLabel.text = convertTimestampToString(timestamp: date ?? 0)
            nameLabel.text = report?.title
        }
    }
    
    var user: User? {
        didSet {
            dateLabel.isHidden = true
            nameLabel.text = "\(user?.lastName ?? "") \(user?.firstName ?? "")"
        }
    }
}
