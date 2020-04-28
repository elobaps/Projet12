//
//  UpdateNoteViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class UpdateNoteViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet private weak var publishedSwitch: UISwitch!
    
    // MARK: - Properties
    
    var noteRepresentable: Note?
    var user: User?
    var notes = [Note]()
    private let noteService: NoteService = NoteService()
    private let authService: AuthService = AuthService()
    private let userService: UserService = UserService()
    
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
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
    }
    
    @IBAction private func saveNoteButtonTapped(_ sender: Any) {
        guard timestampLabel.text != nil else { return }
        guard let title = titleTextField.text else { return }
        guard let noteText = noteTextView.text else { return }
        let publishedNote = publishedSwitch.isOn
        
        guard let uid = authService.currentUID else { return }
        userService.getUserData(with: uid) { (result) in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self.noteService.savedNote(identifier: self.noteRepresentable?.identifier, userFirstName: userData[0].firstName, userLastName: userData[0].lastName, title: title, text: noteText, timestamp: 0, published: publishedNote) { (isSuccess) in
                        if isSuccess {
                            self.performSegue(withIdentifier: "unwindToNoteViewController", sender: nil)
                        } else {
                            self.presentAlert(titre: "Erreur", message: "L'enregistrement a échoué")
                        }
                    }
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des informations a échoué")
                print(error)
            }
        }
    }
    
    // MARK: - Method
    
    private func updateNote() {
        guard let noteRepresentable = noteRepresentable else { return }
        titleTextField.text = noteRepresentable.title
        noteTextView.text = noteRepresentable.text
        let date = noteRepresentable.timestamp
        timestampLabel.text = convertTimestampToString(timestamp: date ?? 0)
        publishedSwitch.isSelected = noteRepresentable.published ?? true
        
        if noteRepresentable.published == true {
           publishedSwitch.setOn(true, animated: false)
        } else {
           publishedSwitch.setOn(false, animated: false)
        }
    }
}
