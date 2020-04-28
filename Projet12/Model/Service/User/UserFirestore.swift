//
//  UserFirestore.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 24/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation
import Firebase

final class UserFirestore: UserType {
    var currentUID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    
    private let db = Firestore.firestore()
    
    /// Method to get users
    func getUsers(callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).getDocuments { (querySnapshot, error) in
            var users = [User]()
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type)
                            users.append(newUser)
                        }
                    }
                    callback(.success(users))
                }
            }
        }
    }
    
    /// Method to get user's data according to his UID
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).getDocuments { (querySnapshot, error) in
            var users = [User]()
            if let err = error {
                callback(.failure(NetworkError.networkError))
                print(err)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type)
                            users.append(newUser)
                        }
                    }
                    callback(.success(users))
                }
            }
        }
    }
    
    /// Method to get users with family filter
    func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userType, isEqualTo: "family").order(by: Constants.FStore.userLastNameField).getDocuments { (querySnapshot, error) in
            var users = [User]()
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type)
                            users.append(newUser)
                        }
                    }
                    callback(.success(users))
                }
            }
        }
    }
    
    /// Method to get users with patient filter
    func getUsersWithPatientFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userType, isEqualTo: "patient").order(by: Constants.FStore.userLastNameField).getDocuments { (querySnapshot, error) in
            var users = [User]()
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type)
                            users.append(newUser)
                        }
                    }
                    callback(.success(users))
                }
            }
        }
    }
    
    /// Method for updating user information
    func updateUserInformations(userFirstName: String, userLastName: String, email: String, callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.userCollectionName).document(Auth.auth().currentUser?.uid ?? "").updateData([
            Constants.FStore.userFirstNameField: userFirstName,
            Constants.FStore.userLastNameField: userLastName,
            Constants.FStore.userEmailField: email
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    /// Method to delete an account
    func deleteAccount(callback: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        currentUser.delete { error in
            if error != nil {
                print("An error happened")
                callback(false)
            } else {
                print("successfully deleted")
                callback(true)
            }
        }
    }
    
    /// Method to delete user's document
    func deletedUserData(callback: @escaping (Bool) -> Void) {
        guard let uid = currentUID else { return }
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).getDocuments { (querySnapshot, _) in
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
