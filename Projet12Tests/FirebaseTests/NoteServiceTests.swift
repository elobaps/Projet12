//
//  NotesServiceTests.swift
//  Projet12Tests
//
//  Created by Elodie-Anne Parquer on 02/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

@testable import Projet12
import XCTest

class NoteServiceTests: XCTestCase {
    
    // MARK: - Helpers
    
    private class NoteStub: NoteType {
        
        private let isSuccess: Bool
        
        var note = [Note]()
        var currentUID: String? { return isSuccess ? "AbCde34z2Abd" : nil }
        
        init(_ isSuccess: Bool) {
            self.isSuccess = isSuccess
        }
        
        func savedNote(identifier: String?, userFirstName: String, userLastName: String, title: String, text: String, timestamp: TimeInterval, published: Bool, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func getNotes(callback: @escaping (Result<[Note], Error>) -> Void) {
            note.append(Note(dictionnary: ["": ""]))
        }
        
        func getNotesPublished(callback: @escaping (Result<[Note], Error>) -> Void) {
            note.append(Note(dictionnary: ["": ""]))
        }
        
        func deletedNote(identifier: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func deleteAllNotes(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
    }
    
    // MARK: - Methods
    
    func createNote() -> Note {
        let dictionnary = [Constants.FStore.identifier: "", Constants.FStore.userUID: "", Constants.FStore.publishedNote: "", Constants.FStore.titleNote: "", Constants.FStore.textNote: "", Constants.FStore.timestamp: nil]
           return Note(dictionnary: dictionnary as [String: Any])
       }
    
    // MARK: - Tests
    
    func testCurrendUID_WhenUserIsConnected_ThenSouldReturnValue() {
        let sut: NoteService = NoteService(note: NoteStub(true))
        let expectedUID: String = "AbCde34z2Abd"
        XCTAssertTrue(sut.currentUID! == expectedUID)
    }
    
    func testNoteSuccessBackup_WhenUserSaveNote_ThenSouldReturnValue() {
        let sut: NoteService = NoteService(note: NoteStub(true))
        let expectedBackup: Bool = true
        sut.savedNote(identifier: "", userFirstName: "", userLastName: "", title: "Jeudi", text: "hello", timestamp: 0, published: true) { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertEqual(isSuccess, expectedBackup)
            }
        }
    }
    
    func testGetNotes_WhenLoadingData_ThenShouldReturnValue() {
        let sut: NoteService = NoteService(note: NoteStub(true))
        let note = createNote()
        sut.getNotes { (result) in
            switch result {
            case .success(let loadedNote):
                XCTAssertEqual(loadedNote, [note])
            case .failure:
                XCTFail("Error")
            }
        }
    }
    
    func testGetNotesPublished_WhenLoadingData_ThenShouldReturnValue() {
        let sut: NoteService = NoteService(note: NoteStub(true))
        let note = createNote()
        sut.getNotesPublished { (result) in
            switch result {
            case .success(let loadedNotePublished):
                XCTAssertEqual(loadedNotePublished, [note])
            case .failure:
                XCTFail("Error")
            }
        }
    }
    
    func testNoteDeletedSuccess_WhenUserRemovesHisNote_ThenShouldReturnValue() {
        let sut: NoteService = NoteService(note: NoteStub(true))
        let identifier = "aBtCfdh3by"
        sut.deletedNote(identifier: identifier) { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(true)
            }
            
        }
    }
    
    func testAllDeletedNote_WhenUserRemovesHisNote_ThenShouldReturnValue() {
        let sut: NoteService = NoteService(note: NoteStub(true))
        sut.deleteAllNotes { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(true)
            }
        }
    }
    
}
