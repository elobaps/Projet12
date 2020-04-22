//
//  ReportFirestore.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation
import Firebase

class ReportFirestore: ReportType {
    
    // MARK: - Properties
    
    var currentUID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    var reports = [Report]()
    var users = [User]()
    
    private let db = Firestore.firestore()
    
    // MARK: - Methods
    
    func savedReport(identifier: String?, forUid: String, title: String, text: String, timestamp: TimeInterval, published: Bool, completion: @escaping (Bool) -> Void) {
        guard let uid = currentUID else { return }
        let timestamp = Date().timeIntervalSince1970
        let uniqueIdentifier = UUID().uuidString
        let newReportRef = db.collection(Constants.FStore.reportCollectionName)
        let refDoc = identifier != nil ? newReportRef.document(identifier!) : newReportRef.document(uniqueIdentifier)
        refDoc.setData([Constants.FStore.userUID: uid, Constants.FStore.reportIdentifier: identifier != nil ? identifier! : uniqueIdentifier, Constants.FStore.reportForUid: forUid, Constants.FStore.titleReport: title, Constants.FStore.textReport: text, Constants.FStore.timestampReport: timestamp, Constants.FStore.publishedReport: published], merge: true) { err in
            if let err = err {
                print("Error adding document: \(err)")
                completion(false)
            } else {
                completion(true)
                print(refDoc)
            }
        }
    }
    
    func getReports(callback: @escaping (Result<[Report], Error>) -> Void) {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        db.collection(Constants.FStore.reportCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).order(by: Constants.FStore.timestampReport, descending: true).addSnapshotListener { (querySnapshot, error) in
            self.reports = []
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let identifier = data[Constants.FStore.reportIdentifier] as? String, let title = data[Constants.FStore.titleReport] as? String, let text = data[Constants.FStore.textReport] as? String, let published = data[Constants.FStore.publishedReport] as? Bool, let timestamp = data[Constants.FStore.timestampReport] as? Double, let forUid = data[Constants.FStore.reportForUid] as? String {
                            let newReport = Report(fromUid: uid, identifier: identifier, title: title, text: text, published: published, timestamp: timestamp, forUid: forUid)
                            self.reports.append(newReport)
                        }
                    }
                    callback(.success(self.reports))
                }
            }
        }
    }
    
    func getReportsPublished(callback: @escaping (Result<[Report], Error>) -> Void) {
        guard let uid = currentUID else { return }
        let ref = db.collection(Constants.FStore.reportCollectionName)
        ref
            .whereField(Constants.FStore.reportForUid, isEqualTo: uid)
            .whereField(Constants.FStore.publishedReport, isEqualTo: true)
            .order(by: Constants.FStore.timestampReport, descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                self.reports = []
                if let err = error {
                    print(err)
                    callback(.failure(NetworkError.networkError))
                } else {
                    if let snapashotDocuments = querySnapshot?.documents {
                        for doc in snapashotDocuments {
                            let data = doc.data()
                            if let uid = data[Constants.FStore.userUID] as? String, let identifier = data[Constants.FStore.reportIdentifier] as? String, let title = data[Constants.FStore.titleReport] as? String, let text = data[Constants.FStore.textReport] as? String, let published = data[Constants.FStore.publishedReport] as? Bool, let timestamp = data[Constants.FStore.timestampReport] as? Double, let forUid = data[Constants.FStore.reportForUid] as? String {
                                let newReport = Report(fromUid: uid, identifier: identifier, title: title, text: text, published: published, timestamp: timestamp, forUid: forUid)
                                self.reports.append(newReport)
                            }
                        }
                        callback(.success(self.reports))
                    }
                }
        }
    }
    
    func deletedReport(identifier: String, callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.reportCollectionName).whereField(Constants.FStore.reportIdentifier, isEqualTo: identifier).getDocuments { (querySnapshot, error) in
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
    
    func deleteAllReports(callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.reportCollectionName).getDocuments { (querySnapshot, error) in
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
    
    func deletedUser(callback: @escaping (Bool) -> Void) {
        guard let uid = currentUID else { return }
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).getDocuments { (querySnapshot, error) in
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
    
    func updateUserInformations(userFirstName: String, userLastName: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.userCollectionName).document(Auth.auth().currentUser?.uid ?? "").updateData([
            Constants.FStore.userFirstNameField: userFirstName,
            Constants.FStore.userLastNameField: userLastName,
            Constants.FStore.userEmailField: email,
            Constants.FStore.userPasswordField: password
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                callback(false)
            } else {
                print("Document successfully updated")
                callback(true)
            }
        }
    }
    
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).getDocuments { (querySnapshot, error) in
            self.users = []
            if let err = error {
                callback(.failure(NetworkError.networkError))
                print(err)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String, let password = data[Constants.FStore.userPasswordField] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type, password: password)
                            self.users.append(newUser)
                        }
                    }
                    callback(.success(self.users))
                }
            }
        }
    }
    
    func getUsers(callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).getDocuments { (querySnapshot, error) in
            self.users = []
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String, let password = data[Constants.FStore.userPasswordField] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type, password: password)
                            self.users.append(newUser)
                        }
                    }
                    callback(.success(self.users))
                }
            }
        }
    }
    
    func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userType, isEqualTo: "family").order(by: Constants.FStore.userLastNameField).getDocuments { (querySnapshot, error) in
            self.users = []
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String, let password = data[Constants.FStore.userPasswordField] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type, password: password)
                            self.users.append(newUser)
                        }
                    }
                    callback(.success(self.users))
                }
            }
        }
    }
    
    func getUsersWithPatientFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userType, isEqualTo: "patient").order(by: Constants.FStore.userLastNameField).getDocuments { (querySnapshot, error) in
            self.users = []
            if let err = error {
                print(err)
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String, let password = data[Constants.FStore.userPasswordField] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type, password: password)
                            self.users.append(newUser)
                        }
                    }
                    callback(.success(self.users))
                }
            }
        }
    }
}
