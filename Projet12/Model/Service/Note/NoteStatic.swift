//
//  NoteStatic.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 26/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

protocol NoteType {
    var currentUID: String? { get }
    func savedNote(fromUid: String, title: String, text: String, timestamp: TimeInterval, published: Bool, callback: @escaping (Bool) -> Void)
    func getNotes(callback: @escaping (Result<[Note], Error>) -> Void)
}

final class NoteStatic: NoteType {
    
    var currentUID: String?
    
    func savedNote(fromUid: String, title: String, text: String, timestamp: TimeInterval, published: Bool, callback: @escaping (Bool) -> Void) {
        callback(true)
    }
    
    func getNotes(callback: @escaping (Result<[Note], Error>) -> Void) {
        callback(callback: callback)
    }
    
}
