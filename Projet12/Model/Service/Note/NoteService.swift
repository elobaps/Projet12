//
//  NoteService.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

protocol NoteType {
    var currentUID: String? { get }
    func savedNote(identifier: String?, userFirstName: String, userLastName: String, title: String, text: String, timestamp: TimeInterval, published: Bool, callback: @escaping (Bool) -> Void)
    func getNotes(callback: @escaping (Result<[Note], Error>) -> Void)
    func getNotesPublished(callback: @escaping (Result<[Note], Error>) -> Void)
    func deletedNote(identifier: String, callback: @escaping (Bool) -> Void)
    func deleteAllNotes(callback: @escaping (Bool) -> Void)
}

final class NoteService {
    
    private let note: NoteType
    var currentUID: String? { return note.currentUID }
    
    init(note: NoteType = NoteFirestore()) {
        self.note = note
    }
    
    func savedNote(identifier: String?, userFirstName: String, userLastName: String, title: String, text: String, timestamp: TimeInterval, published: Bool, callback: @escaping (Bool) -> Void) {
        note.savedNote(identifier: identifier, userFirstName: userFirstName, userLastName: userLastName, title: title, text: text, timestamp: timestamp, published: published, callback: callback)
    }
    
    func getNotes(callback: @escaping (Result<[Note], Error>) -> Void) {
        note.getNotes(callback: callback)
    }
    
    func getNotesPublished(callback: @escaping (Result<[Note], Error>) -> Void) {
        note.getNotesPublished(callback: callback)
    }
    
    func deletedNote(identifier: String, callback: @escaping (Bool) -> Void) {
        note.deletedNote(identifier: identifier, callback: callback)
    }
    
    func deleteAllNotes(callback: @escaping (Bool) -> Void) {
        note.deleteAllNotes(callback: callback)
    }
}
