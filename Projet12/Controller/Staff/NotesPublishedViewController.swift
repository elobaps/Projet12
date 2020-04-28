//
//  NotesViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 08/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class NotesPublishedViewController: UIViewController {
    
    @IBOutlet private weak var notesTableView: UITableView!
    @IBOutlet private weak var navSecondView: UIView!
    
    // MARK: - Properties
    
    var notes = [Note]()
    var noteRepresentable: Note?
    private let noteService: NoteService = NoteService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        navSecondView.configureNavSecondView()
        
        notesTableView.register(UINib(nibName: Constants.Cell.notePublishedNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.notePublishedCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedNotes()
    }
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let updateNoteVC = segue.destination as? ShowNoteViewController else { return }
             updateNoteVC.noteRepresentable = noteRepresentable
     }
    
    private func loadedNotes() {
        noteService.getNotesPublished { (result) in
            switch result {
            case .success(let notes):
                DispatchQueue.main.async {
                    self.notes = notes
                    self.notesTableView.reloadData()
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des notes a échoué")
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension NotesPublishedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.notePublishedCellIdentifier, for: indexPath) as? NotePublishedTableViewCell else { return UITableViewCell() }
        cell.note = note
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        noteRepresentable = note
        performSegue(withIdentifier: Constants.Segue.showNoteSegue, sender: nil)
    }
}

// MARK: - UITableViewDelegate

/// extension that manages the table view and allows the display of a message when the list is empty and the deletion of a cell
extension NotesPublishedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Ajouter des notes à votre liste"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return notes.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // cell's height
        return 70
    }
}
