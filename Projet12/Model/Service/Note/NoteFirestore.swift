//
//  NoteFirestore.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation
import Firebase

class NoteFirestore: NoteType {
    
    // MARK: - Properties
    
    var currentUID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    var notes = [Note]()
    
    private let db = Firestore.firestore()
    
    // MARK: - Methods
    
    func savedNote(identifier: String?, userFirstName: String, userLastName: String, title: String, text: String, timestamp: TimeInterval, published: Bool, callback: @escaping (Bool) -> Void) {
        guard let uid = currentUID else { return }
        let timestamp = Date().timeIntervalSince1970
        let uniqueIdentifier = UUID().uuidString
        let newNoteRef = db.collection(Constants.FStore.noteCollectionName)
        let refNote = identifier != nil ? newNoteRef.document(identifier!) : newNoteRef.document(uniqueIdentifier)
        refNote.setData([Constants.FStore.userUID: uid, Constants.FStore.identifier: identifier != nil ? identifier! : uniqueIdentifier, Constants.FStore.textNote: text, Constants.FStore.titleNote: title, Constants.FStore.timestamp: timestamp, Constants.FStore.publishedNote: published, Constants.FStore.noteFirstName: userFirstName, Constants.FStore.noteLastName: userLastName], merge: true) { (error) in
            if let err = error {
                print("there was an issue saving data to firestore, \(err)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    func getNotes(callback: @escaping (Result<[Note], Error>) -> Void) {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        db.collection(Constants.FStore.noteCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).order(by: Constants.FStore.timestamp, descending: true).addSnapshotListener({ (querySnapshot, error) in
            self.notes = []
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let identifier = data[Constants.FStore.identifier] as? String, let title = data[Constants.FStore.titleNote] as? String, let text = data[Constants.FStore.textNote] as? String, let published = data[Constants.FStore.publishedNote] as? Bool, let timestamp = data[Constants.FStore.timestamp] as? Double, let userFirstName = data[Constants.FStore.noteFirstName] as? String, let userLastName = data[Constants.FStore.noteLastName] as? String {
                            let newNote = Note(fromUid: uid, identifier: identifier, title: title, text: text, published: published, timestamp: timestamp, firstName: userFirstName, lastName: userLastName)
                            self.notes.append(newNote)
                        }
                    }
                    callback(.success(self.notes))
                }
                
            }
        })
    }
    
    func getNotesPublished(callback: @escaping (Result<[Note], Error>) -> Void) {
        db.collection(Constants.FStore.noteCollectionName).whereField(Constants.FStore.publishedNote, isEqualTo: true).order(by: Constants.FStore.timestamp, descending: true).addSnapshotListener({ (querySnapshot, error) in
            self.notes = []
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let identifier = data[Constants.FStore.identifier] as? String, let title = data[Constants.FStore.titleNote] as? String, let text = data[Constants.FStore.textNote] as? String, let published = data[Constants.FStore.publishedNote] as? Bool, let timestamp = data[Constants.FStore.timestamp] as? Double, let userFirstName = data[Constants.FStore.noteFirstName] as? String, let userLastName = data[Constants.FStore.noteLastName] as? String {
                            let newNote = Note(fromUid: uid, identifier: identifier, title: title, text: text, published: published, timestamp: timestamp, firstName: userFirstName, lastName: userLastName)
                            self.notes.append(newNote)
                        }
                    }
                    callback(.success(self.notes))
                }
                
            }
        })
    }
    
    func deletedNote(identifier: String, callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.noteCollectionName).whereField(Constants.FStore.identifier, isEqualTo: identifier).getDocuments { (querySnapshot, error) in
            if let err = error {
                print ("Error removing document : \(err)")
                callback(false)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        doc.reference.delete()
                        print ("Document successfuly deleted")
                    }
                    callback(true)
                }
            }
        }
    }
    
    func deleteAllNotes(callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.noteCollectionName).getDocuments { (querySnapshot, error) in
            if let err = error {
                print ("Error removing all documents : \(err)")
                callback(false)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        doc.reference.delete()
                        print ("All documents successfuly deleted")
                    }
                    callback(true)
                }
            }
        }
    }
}
