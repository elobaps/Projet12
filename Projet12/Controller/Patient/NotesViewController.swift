//
//  NotesViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 25/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var noteTableView: UITableView! { didSet { noteTableView.tableFooterView = UIView() }}
    
    // MARK: - Properties
    
    var notes = [Note]()
    var noteRepresentable: Note?
    private let noteService: NoteService = NoteService()
    var selectedSegue: Int = Int()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        noteTableView.register(UINib(nibName: Constants.Cell.noteNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.noteCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedNotes()
    }
    
    @IBAction private func unwindToNoteViewController(_ segue: UIStoryboardSegue) {}
    
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        selectedSegue = 1
        performSegue(withIdentifier: Constants.Segue.updateNoteSegue, sender: nil)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        noteService.deleteAllNotes { (isSuccess) in
            if isSuccess {
                self.loadedNotes()
            } else {
                self.presentAlert(titre: "Erreur", message: "La suppression a échoué")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let updateNoteVC = segue.destination as? UpdateNoteViewController else { return }
        if selectedSegue == 2 {
            updateNoteVC.noteRepresentable = noteRepresentable
        }
    }
    
    private func deletedNote(identifier: String) {
        noteService.deletedNote(identifier: identifier) { (isSuccess) in
            if !isSuccess {
                self.presentAlert(titre: "Erreur", message: "La suppression a échoué")
            }
        }
    }
    
    private func loadedNotes() {
        noteService.getNotes { (result) in
            switch result {
            case .success(let notes):
                DispatchQueue.main.async {
                    self.notes = notes
                    self.noteTableView.reloadData()
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des notes a échoué")
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.noteCellIdentifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }
        cell.note = note
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        selectedSegue = 2
        noteRepresentable = note
        performSegue(withIdentifier: Constants.Segue.updateNoteSegue, sender: nil)
    }
}

// MARK: - UITableViewDelegate

/// extension that manages the table view and allows the display of a message when the list is empty and the deletion of a cell
extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deletedNote(identifier: notes[indexPath.row].identifier)
            notes.remove(at: indexPath.row)
            noteTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            noteTableView.reloadData()
        }
    }
    
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
        return 91
    }
}
