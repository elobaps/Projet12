//
//  ShowNoteViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class ShowNoteViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    // MARK: - Properties
    
    var noteRepresentable: Note?
//    var notes = [Note]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        updateNote()
    }
    
    // MARK: - Method
    
    func updateNote() {
        guard let noteRepresentable = noteRepresentable else { return }
        titleLabel.text = noteRepresentable.title
        noteTextView.text = noteRepresentable.text
        let date = noteRepresentable.timestamp
        timestampLabel.text = convertTimestampToString(timestamp: date)
    }
}
