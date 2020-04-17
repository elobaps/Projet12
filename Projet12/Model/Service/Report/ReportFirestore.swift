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
    
    var currentUID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    var reports = [Report]()
    var users = [User]()
    
    private let db = Firestore.firestore()
    
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
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        let reportsUserRef = db.collection(Constants.FStore.reportCollectionName)
        reportsUserRef
            .whereField(Constants.FStore.publishedReport, isEqualTo: true)
            .whereField(Constants.FStore.reportForUid, isEqualTo: uid)
            .order(by: Constants.FStore.timestamp, descending: true)
        reportsUserRef.addSnapshotListener ({ (querySnapshot, error) in
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
        })
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
    
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void) {
        db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).getDocuments { (querySnapshot, error) in
            self.users = []
            if let err = error {
                callback(.failure(NetworkError.networkError))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String {
                            let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type)
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
                            if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String {
                                let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type)
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
                            if let uid = data[Constants.FStore.userUID] as? String, let email = data[Constants.FStore.userEmailField] as? String, let firstName = data[Constants.FStore.userFirstNameField] as? String, let lastName = data[Constants.FStore.userLastNameField] as? String, let type = data[Constants.FStore.userType] as? String {
                                let newUser = User(uid: uid, email: email, firstName: firstName, lastName: lastName, type: type)
                                self.users.append(newUser)
                            }
                        }
                        callback(.success(self.users))
                    }
                }
            }
        }
        
}
