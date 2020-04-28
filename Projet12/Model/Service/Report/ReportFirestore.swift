//
//  ReportFirestore.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation
import Firebase

final class ReportFirestore: ReportType {
    
    // MARK: - Properties
    
    var currentUID: String? {
        return Firebase.Auth.auth().currentUser?.uid
    }
    
    private let db = Firestore.firestore()
    
    // MARK: - Methods
    
    /// Method to save a report on the staff side
    func savedReport(identifier: String?, forUid: String, title: String, text: String, timestamp: TimeInterval, published: Bool, completion: @escaping (Bool) -> Void) {
        guard let uid = currentUID else { return }
        let timestamp = Date().timeIntervalSince1970
        let uniqueIdentifier = UUID().uuidString
        let newReportRef = db.collection(Constants.FStore.reportCollectionName)
        let refDoc = identifier != nil ? newReportRef.document(identifier ?? "") : newReportRef.document(uniqueIdentifier)
        refDoc.setData([Constants.FStore.userUID: uid, Constants.FStore.reportIdentifier: identifier != nil ? identifier ?? "" : uniqueIdentifier, Constants.FStore.reportForUid: forUid, Constants.FStore.titleReport: title, Constants.FStore.textReport: text, Constants.FStore.timestampReport: timestamp, Constants.FStore.publishedReport: published], merge: true) { err in
            if let err = err {
                print("Error adding document: \(err)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    /// Method to get reports
    func getReports(callback: @escaping (Result<[Report], Error>) -> Void) {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        db.collection(Constants.FStore.reportCollectionName).whereField(Constants.FStore.userUID, isEqualTo: uid).order(by: Constants.FStore.timestampReport, descending: true).addSnapshotListener { (querySnapshot, _) in
            var reports = [Report]()
            guard let documents = querySnapshot?.documents else {
                callback(.failure(NetworkError.networkError))
                return
            }
            for doc in documents {
                let data = doc.data()
                let report = Report(dictionnary: data)
                reports.append(report)
            }
            callback(.success(reports))
        }
    }
    
    /// Method to get published reports in family side
    func getReportsPublished(callback: @escaping (Result<[Report], Error>) -> Void) {
        guard let uid = currentUID else { return }
        let ref = db.collection(Constants.FStore.reportCollectionName)
        ref
            .whereField(Constants.FStore.reportForUid, isEqualTo: uid)
            .whereField(Constants.FStore.publishedReport, isEqualTo: true)
            .order(by: Constants.FStore.timestampReport, descending: true)
            .addSnapshotListener { (querySnapshot, _) in
                var reports = [Report]()
                guard let documents = querySnapshot?.documents else {
                    callback(.failure(NetworkError.networkError))
                    return
                }
                for doc in documents {
                    let data = doc.data()
                    let report = Report(dictionnary: data)
                    reports.append(report)
                }
                callback(.success(reports))
        }
    }
    
    /// Method to delete a report
    func deletedReport(identifier: String, callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.reportCollectionName).whereField(Constants.FStore.reportIdentifier, isEqualTo: identifier).getDocuments { (querySnapshot, _) in
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
    
    /// Method to delete all reports
    func deleteAllReports(callback: @escaping (Bool) -> Void) {
        db.collection(Constants.FStore.reportCollectionName).getDocuments { (querySnapshot, _) in
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
