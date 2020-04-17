//
//  UpdateNoteViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class UpdateNoteViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var publishedSwitch: UISwitch!
    
    // MARK: - Properties
    
    var noteRepresentable: Note?
    var notes = [Note]()
    private let noteService: NoteService = NoteService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        updateNote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
    }
    
    @IBAction func saveNoteButtonTapped(_ sender: Any) {
        guard timestampLabel.text != nil else { return }
        guard let title = titleTextField.text else { return }
        guard let noteText = noteTextView.text else { return }
        let publishedNote = publishedSwitch.isOn
        let identifier = UUID().uuidString
            noteService.savedNote(fromUid: "", identifier: identifier, title: title, text: noteText, timestamp: 0, published: publishedNote) { (isSuccess) in
                if isSuccess {
                    self.performSegue(withIdentifier: "unwindToNoteViewController", sender: nil)
                } else {
                    self.presentAlert(titre: "Erreur", message: "L'enregistrement a échoué")
                }
            }
    }
    
    // MARK: - Method
    
    func updateNote() {
        guard let noteRepresentable = noteRepresentable else { return }
        titleTextField.text = noteRepresentable.title
        noteTextView.text = noteRepresentable.text
        let date = noteRepresentable.timestamp
        timestampLabel.text = convertTimestampToString(timestamp: date)
        publishedSwitch.isSelected = noteRepresentable.published
        
        if noteRepresentable.published == true {
           publishedSwitch.setOn(true, animated: false)
        } else {
           publishedSwitch.setOn(false, animated: false)
        }
    }
}
