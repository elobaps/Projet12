//
//  UpdateNoteViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit
import Network

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
    var isConnectionOK: Bool = true
    private let monitor = NWPathMonitor()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        updateNote()
        
        noteTextView.delegate = self
        noteTextView.text = "Veuillez renseigner une description"
        noteTextView.textColor = UIColor.lightGray
        
        monitor.start(queue: DispatchQueue.global(qos: .background))
        monitor.pathUpdateHandler = { path in
            self.isConnectionOK = path.status == .satisfied
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let timestamp = Date().timeIntervalSince1970
        timestampLabel.text = convertTimestampToString(timestamp: timestamp)
    }
    
    deinit {
           monitor.cancel()
       }
    
    // MARK: - Actions
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
    }
    
    @IBAction private func saveNoteButtonTapped(_ sender: Any) {
        if isConnectionOK {
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
            
        } else {
            self.presentAlert(titre: "Erreur", message: "Veuillez vérifier votre connexion internet")
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

extension UpdateNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = nil
            noteTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteTextView.text.isEmpty {
            noteTextView.text = "Veuillez renseigner une description"
            noteTextView.textColor = UIColor.lightGray
        }
    }
}
