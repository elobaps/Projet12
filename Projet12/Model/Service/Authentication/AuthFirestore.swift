//
//  AuthFirestore.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 18/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation
import Firebase

final class AuthFirestore: AuthType {
    
    // MARK: - Properties
    
    var currentUID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    
    private let db = Firestore.firestore()
    
    // MARK: - Methods
    
    /// Firebase logIn
    func signIn(type: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { (authResult, _) in
            guard authResult?.user != nil else {
                callback(false)
                return
            }
            self.db.collection(Constants.FStore.userCollectionName).whereField("uid", isEqualTo: self.currentUID ?? String()).getDocuments { (querySnapshot, _) in
                guard let data = querySnapshot?.documents.first?.data() else {
                    callback(false)
                    return
                }
                guard let userType = data[Constants.FStore.userType] as? String else {
                    callback(false)
                    return
                }
                callback(type == userType ? true : false)
            }
        }
    }
    
    /// Firebase register
    func signUp(type: String, userFirstName: String, userLastName: String, email: String,
                password: String, callback: @escaping (Bool) -> Void) {
        Firebase.Auth.auth().createUser(withEmail: email, password: password) {(_, error) in
            guard let uid = Auth.auth().currentUser?.uid else {
                callback(false)
                return
            }
            let data = [Constants.FStore.userFirstNameField: userFirstName, Constants.FStore.userLastNameField: userLastName, Constants.FStore.userEmailField: email, Constants.FStore.userType: type, Constants.FStore.userUID: uid]
            self.db.collection(Constants.FStore.userCollectionName).document("\(uid)").setData(data) { (error) in
                if error != nil {
                    callback(false)
                } else {
                    callback(true)
                }
            }
        }
    }
    
    /// Firebase register with a specific field of patient id
    func signUpFamily(type: String, userFirstName: String, userLastName: String, email: String,
                      password: String, patientUid: String, callback: @escaping (Bool) -> Void) {
        Firebase.Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if error != nil {
                callback(false)
            } else {
                self.db.collection(Constants.FStore.userCollectionName).addDocument(data: [Constants.FStore.userFirstNameField: userFirstName, Constants.FStore.userLastNameField: userLastName, Constants.FStore.userEmailField: email, Constants.FStore.userType: type, Constants.FStore.userUID: authResult?.user.uid ?? "", Constants.FStore.userPatientUID: patientUid]) { (error) in
                    if error != nil {
                        callback(false)
                    } else {
                        callback(true)
                    }
                }
            }
        }
    }
    
    /// Firebase logout
    func signOut(callback: @escaping (Bool) -> Void) {
        do {
            try Firebase.Auth.auth().signOut()
            callback(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            callback(false)
        }
    }
    
    /// Firebase observation of a user connection
    func isUserConnected(callback: @escaping (Bool) -> Void) {
        _ = Firebase.Auth.auth().addStateDidChangeListener { (_, user) in
            guard user != nil else {
                callback(false)
                return
            }
            callback(true)
        }
    }
    
    /// Firebase reset password
    func resetPassword(email: String, completion: @escaping (Bool) -> Void) {
         Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
     }
    }
}
