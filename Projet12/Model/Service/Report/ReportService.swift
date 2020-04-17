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
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void)
    func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void)
}

class ReportService {
    
    private let report: ReportType
    var currentUID: String? { return report.currentUID }
    
    init(report: ReportType = ReportFirestore()) {
        self.report = report
    }
    
    func savedReport(identifier: String?, forUid: String, title: String, text: String, timestamp: TimeInterval, published: Bool, completion: @escaping (Bool) -> Void) {
        report.savedReport(identifier: identifier, forUid: forUid, title: title, text: text, timestamp: timestamp, published: published, completion: completion)
    }
    
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void) {
        report.getUserData(with: uid, callback: callback)
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
    
    func getUsers(callback: @escaping (Result<[User], Error>) -> Void) {
        report.getUsers(callback: callback)
    }
    
    func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        report.getUsersWithFamilyFilter(callback: callback)
    }
    
}
