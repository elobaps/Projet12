//
//  AuthFirestore.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 18/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation
import Firebase

class AuthFirestore: AuthType {
    var currentUID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    
    let db = Firestore.firestore()
    
    func signIn(type: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                print(user)
                self.db.collection(Constants.FStore.userCollectionName).whereField("uid", isEqualTo: self.currentUID ?? String()).getDocuments { (querySnapchot, error) in
                    guard let data = querySnapchot?.documents.first?.data() else {
                        callback(false)
                         print(error ?? "erreur")
                        return
                    }
                    guard let userType = data[Constants.FStore.userType] as? String else {
                        callback(false)
                        return
                    }
                    callback(type == userType ? true : false)
                }
            } else {
                print(error ?? "erreur")
                callback(false)
            }
        }
    }
    
    func signUp(type: String, userFirstName: String, userLastName: String, email: String,
                password: String, callback: @escaping (Bool) -> Void) {
        Firebase.Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if error != nil {
                print(error ?? "erreur")
                callback(false)
            } else {
                self.db.collection(Constants.FStore.userCollectionName).addDocument(data: [Constants.FStore.userFirstNameField: userFirstName, Constants.FStore.userLastNameField: userLastName, Constants.FStore.userEmailField: email, Constants.FStore.userPasswordField: password, Constants.FStore.userType: type, Constants.FStore.userUID: authResult?.user.uid ?? ""]) { (error) in
                    if error != nil {
                        print(error ?? "erreur")
                        callback(false)
                    } else {
                        print(authResult?.user ?? "")
                        callback(true)
                    }
                }
            }
        }
    }
    
    func signUpFamily(type: String, userFirstName: String, userLastName: String, email: String,
                      password: String, patientUid: String, callback: @escaping (Bool) -> Void) {
           Firebase.Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
               if error != nil {
                   print(error ?? "erreur")
                   callback(false)
               } else {
                self.db.collection(Constants.FStore.userCollectionName).addDocument(data: [Constants.FStore.userFirstNameField: userFirstName, Constants.FStore.userLastNameField: userLastName, Constants.FStore.userEmailField: email, Constants.FStore.userPasswordField: password, Constants.FStore.userType: type, Constants.FStore.userUID: authResult?.user.uid ?? "", Constants.FStore.userPatientUID: patientUid]) { (error) in
                       if error != nil {
                           print(error ?? "erreur")
                           callback(false)
                       } else {
                           print(authResult?.user ?? "")
                           callback(true)
                       }
                   }
               }
           }
       }
    
    func signOut(callback: @escaping (Bool) -> Void) {
        do {
            try Firebase.Auth.auth().signOut()
            callback(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            callback(false)
        }
    }
    
    func isUserConnected(callback: @escaping (Bool) -> Void) {
        _ = Firebase.Auth.auth().addStateDidChangeListener { (_, user) in
            guard (user != nil) else {
                callback(false)
                return
            }
            callback(true)
        }
    }
}
