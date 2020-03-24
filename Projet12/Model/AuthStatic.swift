//
//  AuthStatic.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 13/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

protocol AuthType {
    var currentUID: String? { get }
    func signIn(type: String, email: String, password: String, callback: @escaping (Bool) -> Void)
    func signUp(type: String, userFirstName: String, userLastName: String,
                email: String, password: String, callback: @escaping (Bool) -> Void)
    func signOut(callback: @escaping (Bool) -> Void)
    func isUserConnected(callback: @escaping (Bool) -> Void)
}

final class AuthStatic: AuthType {
    var currentUID: String? = ""
    
    func signIn(type: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        callback(true)
    }
    
    func signUp(type: String, userFirstName: String, userLastName: String,
                email: String, password: String, callback: @escaping (Bool) -> Void) {
        callback(true)
    }
    
    func signOut(callback: @escaping (Bool) -> Void) {
        callback(true)
    }
    
    func isUserConnected(callback: @escaping (Bool) -> Void) {
        callback(false)
    }
}
