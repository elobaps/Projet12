//
//  NotePublishedTableViewCell.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 08/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class NotePublishedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let reportService: ReportService = ReportService()
    var users = [User]()
    
    var note: Note? {
        didSet {
            setupUserName()
            let date = note?.timestamp
            dateLabel.text = convertTimestampToString(timestamp: date ?? 0)
        }
    }
    
    var report: Report? {
        didSet {
            let date = report?.timestamp
            dateLabel.text = convertTimestampToString(timestamp: date ?? 0)
            firstNameLabel.text = report?.title
            lastNameLabel.isHidden = true
        }
    }
    
    func setupUserName() {
        if let id = note?.fromUid {
            reportService.getUsers { (result) in
                switch result {
                case .success(let users) :
                    for user in users {
                        self.firstNameLabel.text = user.firstName
                        self.lastNameLabel.text = user.lastName
                    }
                case .failure(let error) :
                    print(error)
                }
            }
        }
    }
    
}
