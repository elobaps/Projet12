//
//  ReportService.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

protocol ReportType {
    var currentUID: String? { get }
    func savedReport(identifier: String?, forUid: String, title: String, text: String, timestamp: TimeInterval, published: Bool, completion: @escaping (Bool) -> Void)
    func getReports(callback: @escaping (Result<[Report], Error>) -> Void)
    func getReportsPublished(callback: @escaping (Result<[Report], Error>) -> Void)
    func deletedReport(identifier: String, callback: @escaping (Bool) -> Void)
    func deleteAllReports(callback: @escaping (Bool) -> Void)
    func getUsers(callback: @escaping (Result<[User], Error>) -> Void)
    func deleteAccount(callback: @escaping (Bool) -> Void)
    func deletedUser(callback: @escaping (Bool) -> Void)
    func updateUserInformations(userFirstName: String, userLastName: String, email: String, password: String, callback: @escaping (Bool) -> Void)
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void)
    func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void)
    func getUsersWithPatientFilter(callback: @escaping (Result<[User], Error>) -> Void)
}

class ReportService {
    
    private let report: ReportType
    private let user: ReportType
    var currentUID: String? { return report.currentUID }
    
    init(report: ReportType = ReportFirestore(), user: ReportType = ReportFirestore()) {
        self.report = report
        self.user = user
    }
    
    func savedReport(identifier: String?, forUid: String, title: String, text: String, timestamp: TimeInterval, published: Bool, completion: @escaping (Bool) -> Void) {
        report.savedReport(identifier: identifier, forUid: forUid, title: title, text: text, timestamp: timestamp, published: published, completion: completion)
    }
    
    func getReports(callback: @escaping (Result<[Report], Error>) -> Void) {
        report.getReports(callback: callback)
    }
    
    func getReportsPublished(callback: @escaping (Result<[Report], Error>) -> Void) {
        report.getReportsPublished(callback: callback)
    }
    
    func deletedReport(identifier: String, callback: @escaping (Bool) -> Void) {
        report.deletedReport(identifier: identifier, callback: callback)
    }
    
    func deleteAllReport(callback: @escaping (Bool) -> Void) {
        report.deleteAllReports(callback: callback)
      }
    
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void) {
        user.getUserData(with: uid, callback: callback)
    }
    
    func getUsers(callback: @escaping (Result<[User], Error>) -> Void) {
        user.getUsers(callback: callback)
    }
    
    func updateUserInformations(userFirstName: String, userLastName: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        user.updateUserInformations(userFirstName: userFirstName, userLastName: userLastName, email: email, password: password, callback: callback)
    }
    
    func deletedUser(callback: @escaping (Bool) -> Void) {
        user.deletedUser(callback: callback)
    }
    
    func deleteAccount(callback: @escaping (Bool) -> Void) {
        user.deleteAccount(callback: callback)
    }
    
    func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        user.getUsersWithFamilyFilter(callback: callback)
    }
    
    func getUsersWithPatientFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        user.getUsersWithPatientFilter(callback: callback)
    }
    
}
