//
//  NoteTableViewCell.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 25/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class NoteTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var publishedImageView: UIImageView!
    
    var note: Note? {
        didSet {
            let date = note?.timestamp
            dateLabel.text = convertTimestampToString(timestamp: date ?? 0)
            titleLabel.text = note?.title
            if note?.published == true {
                publishedImageView.image = UIImage(named: "publishedTrue")
            } else {
                publishedImageView.image = .none
            }
        }
    }
    
    var report: Report? {
           didSet {
            let date = report?.timestamp
               dateLabel.text = convertTimestampToString(timestamp: date ?? 0)
               titleLabel.text = report?.title
               if report?.published == true {
                   publishedImageView.image = UIImage(named: "publishedTrue")
               } else {
                   publishedImageView.image = .none
               }
           }
       }
}
