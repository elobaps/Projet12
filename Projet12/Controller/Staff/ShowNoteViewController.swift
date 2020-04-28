//
//  ShowNoteViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class ShowNoteViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var noteTextView: UITextView!
    
    // MARK: - Properties
    
    var noteRepresentable: Note?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        updateNote()
    }
    
    // MARK: - Method
    
    private func updateNote() {
        guard let noteRepresentable = noteRepresentable else { return }
        titleLabel.text = noteRepresentable.title
        noteTextView.text = noteRepresentable.text
        let date = noteRepresentable.timestamp
        timestampLabel.text = convertTimestampToString(timestamp: date!)
    }
}
