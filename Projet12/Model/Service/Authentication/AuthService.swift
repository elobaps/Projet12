//
//  AuthService.swift
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
    func signUpFamily(type: String, userFirstName: String, userLastName: String,
                      email: String, password: String, patientUid: String, callback: @escaping (Bool) -> Void)
    func signOut(callback: @escaping (Bool) -> Void)
    func isUserConnected(callback: @escaping (Bool) -> Void)
}

class AuthService {
    private let auth: AuthType
    var currentUID: String? { return auth.currentUID }
    
    init(auth: AuthType = AuthFirestore()) {
        self.auth = auth
    }
    
    func signIn(type: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        auth.signIn(type: type, email: email, password: password, callback: callback)
    }
    
    func signUp(type: String, userFirstName: String, userLastName: String, email: String,
                password: String, callback: @escaping (Bool) -> Void) {
        auth.signUp(type: type, userFirstName: userFirstName, userLastName: userLastName,
                    email: email, password: password, callback: callback)
    }
    func signUpFamily(type: String, userFirstName: String, userLastName: String,
                      email: String, password: String, patientUid: String, callback: @escaping (Bool) -> Void) {
        auth.signUpFamily(type: type, userFirstName: userFirstName, userLastName: userLastName, email: email, password: password, patientUid: patientUid, callback: callback)
    }
    
    func signOut(callback: @escaping (Bool) -> Void) {
        auth.signOut(callback: callback)
    }
    
    func isUserConnected(callback: @escaping (Bool) -> Void) {
        auth.isUserConnected(callback: callback)
    }
}
