//
//  NoteFirestore.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation
import Firebase

final class NoteFirestore: NoteType {
    
    // MARK: - Properties
    
    var currentUID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    
    private let db = Firestore.firestore()
    
    // MARK: - Methods
    
    /// Method to save a note on the patient side
    func savedNote(identifier: String?, userFirstName: String, userLastName: String, title: String, text: String, timestamp: TimeInterval, published: Bool, callback: @escaping (Bool) -> Void) {
        guard let uid = currentUID else { return }
        let timestamp = Date().timeIntervalSince1970
        let uniqueIdentifier = UUID().uuidString
        let newNoteRef = db.collection(Constants.FStore.noteCollectionName)
        let refNote = identifier != nil ? newNoteRef.document(identifier ?? "") : newNoteRef.document(uniqueIdentifier)
        refNote.setData([Constants.FStore.userUID: uid, Constants.FStore.identifier: identifier != nil ? identifier ?? "" : uniqueIdentifier, Constants.FStore.textNote: text, Constants.FStore.titleNote: title, Constants.FStore.timestamp: timestamp, Constants.FStore.publishedNote: published, Constants.FStore.noteFirstName: userFirstName, Constants.FStore.noteLastName: userLastName], merge: true) { (error) in
            if let err = error {
                print("Error adding document: \(err)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    /// Method to get notes
    func getNotes(callback: @escaping (Result<[Note], Error>) -> Void) {
        guard let uid = currentUID else { return }
        db.collection(Constants.FStore.noteCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).order(by: Constants.FStore.timestamp, descending: true).addSnapshotListener({ (querySnapshot, _) in
            var notes = [Note]()
            guard let documents = querySnapshot?.documents else {
                callback(.failure(NetworkError.networkError))
                return
            }
            for doc in documents {
                let data = doc.data()
                let note = Note(dictionnary: data)
                notes.append(note)
            }
            callback(.success(notes))
        })
    }
    
    /// Method to get published notes in staff side
    func getNotesPublished(callback: @escaping (Result<[Note], Error>) -> Void) {
        db.collection(Constants.FStore.noteCollectionName).whereField(Constants.FStore.publishedNote, isEqualTo: true).order(by: Constants.FStore.timestamp, descending: true).addSnapshotListener({ (querySnapshot, _) in
            var notes = [Note]()
            guard let documents = querySnapshot?.documents else {
                callback(.failure(NetworkError.networkError))
                return
            }
            for doc in documents {
                let data = doc.data()
                let note = Note(dictionnary: data)
                notes.append(note)
            }
            callback(.success(notes))
        })
    }
    
    /// Method to delete a note
    func deletedNote(identifier: String, callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.noteCollectionName).whereField(Constants.FStore.identifier, isEqualTo: identifier).getDocuments { (querySnapshot, _) in
            guard let documents = querySnapshot?.documents else {
                callback(false)
                return
            }
            for doc in documents {
                doc.reference.delete()
            }
            callback(true)
        }
    }
    
     /// Method to delete all notes
    func deleteAllNotes(callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.noteCollectionName).getDocuments { (querySnapshot, _) in
            guard let documents = querySnapshot?.documents else {
                callback(false)
                return
            }
            for doc in documents {
                doc.reference.delete()
            }
            callback(true)
        }
    }
}
