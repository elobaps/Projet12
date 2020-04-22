//
//  ReportServiceTests.swift
//  Projet12Tests
//
//  Created by Elodie-Anne Parquer on 15/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

@testable import Projet12
import XCTest

class ReportServiceTests: XCTestCase {
    
    // MARK: - Helpers
    
    private class ReportStub: ReportType {
        
        private let isSuccess: Bool
        
        var report = [Report]()
        var user = [User]()
        
        var currentUID: String? { return isSuccess ? "AbCde34z2Abd" : nil }
        
        init(_ isSuccess: Bool) {
            self.isSuccess = isSuccess
        }
        
        func savedReport(identifier: String?, forUid: String, title: String, text: String, timestamp: TimeInterval, published: Bool, completion: @escaping (Bool) -> Void) {
            completion(isSuccess)
        }
        
        func getReports(callback: @escaping (Result<[Report], Error>) -> Void) {
            report.append(Report(fromUid: "", identifier: "", title: "", text: "", published: true, timestamp: 0, forUid: ""))
        }
        
        func getReportsPublished(callback: @escaping (Result<[Report], Error>) -> Void) {
            report.append(Report(fromUid: "", identifier: "", title: "", text: "", published: true, timestamp: 0, forUid: ""))
        }
        
        func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void) {
            user.append(User(uid: "", email: "", firstName: "", lastName: "", type: "", password: ""))
        }
        
        func updateUserInformations(userFirstName: String, userLastName: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func getUsers(callback: @escaping (Result<[User], Error>) -> Void) {
            user.append(User(uid: "", email: "", firstName: "", lastName: "", type: "", password: ""))
        }
        
        func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void) {
            user.append(User(uid: "", email: "", firstName: "", lastName: "", type: "", password: ""))
        }
        
        func getUsersWithPatientFilter(callback: @escaping (Result<[User], Error>) -> Void) {
            user.append(User(uid: "", email: "", firstName: "", lastName: "", type: "", password: ""))
        }
        
        func deleteAccount(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func deletedUser(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func deletedReport(identifier: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func deleteAllReports(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
    }
    
    // MARK: - Methods
    
    func createUser() -> User {
        return User(uid: "", email: "", firstName: "", lastName: "", type: "", password: "")
    }
    
    func createReport() -> Report {
        return Report(fromUid: "", identifier: "", title: "", text: "", published: true, timestamp: 0, forUid: "")
    }
    
    // MARK: - Tests
    
    func testCurrendUID_WhenUserIsConnected_ThenSouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let expectedUID: String = "AbCde34z2Abd"
        XCTAssertTrue(sut.currentUID! == expectedUID)
    }
    
    func testSuccessBackup_WhenUserSaveReport_ThenSouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let expectedBackup: Bool = true
        sut.savedReport(identifier: "", forUid: "", title: "", text: "", timestamp: 0, published: true, completion: { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertEqual(isSuccess, expectedBackup)
            }
        })
    }
    
    func testGetReports_WhenLoadingData_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let report = createReport()
        sut.getReports { (result) in
            switch result {
            case .success(let loadedReports):
                XCTAssertEqual(loadedReports, [report])
            case .failure:
                XCTFail("Error")
            }
        }
    }
    
    func testGetReportsPublished_WhenLoadingData_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let report = createReport()
        sut.getReportsPublished { (result) in
            switch result {
            case .success(let loadedReportsPublished):
                XCTAssertEqual(loadedReportsPublished, [report])
            case .failure:
                XCTFail("Error")
            }
        }
    }
    
    func testGetUserData_WhenLoadingData_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let user = createUser()
        sut.getUserData(with: "AbCde34z2Abd") { (result) in
            switch result {
            case .success(let userData):
                XCTAssertEqual(userData, [user])
            case .failure:
                XCTFail("Error")
            }
        }
    }
    
    func testUpdateUserInformations_WhenLoadingData_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        sut.updateUserInformations(userFirstName: "", userLastName: "", email: "", password: "") { (isSuccess) in
           if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssert(true)
            }
        }
    }
    
    func testGetUsers_WhenLoadingData_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let users = createUser()
        sut.getUsers { (result) in
            switch result {
            case .success(let usersData):
                XCTAssertEqual(usersData, [users])
            case .failure:
                XCTFail("Error")
            }
        }
    }
    
    func testGetUsersWithFamilyFilter_WhenLoadingData_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let users = createUser()
        sut.getUsersWithFamilyFilter { (result) in
            switch result {
            case .success(let usersWithFilter):
                XCTAssertEqual(usersWithFilter, [users])
            case .failure:
                XCTFail("Error")
            }
        }
    }
    
    func testGetUsersWithPatientFilter_WhenLoadingData_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let users = createUser()
        sut.getUsersWithPatientFilter { (result) in
            switch result {
            case .success(let usersWithFilter):
                XCTAssertEqual(usersWithFilter, [users])
            case .failure:
                XCTFail("Error")
            }
        }
    }
    
    func testDeletedSuccess_WhenUserRemovesHisProfil_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        sut.deleteAccount { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(true)
            }
        }
    }
    
    func testDeletedSuccess_WhenUserRemovesHisInformationsData_ThenShouldReturnValue() {
          let sut: ReportService = ReportService(report: ReportStub(true))
          sut.deletedUser { (isSuccess) in
              if !isSuccess {
                  XCTFail("Error")
                  return
              } else {
                  XCTAssertTrue(true)
              }
          }
      }
    
    func testDeletedSuccess_WhenUserRemovesHisReport_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        let identifier = "aBtCfdh3by"
        sut.deletedReport(identifier: identifier) { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(true)
            }
        }
    }
    
    func testAllDeleted_WhenUserRemovesHisReports_ThenShouldReturnValue() {
        let sut: ReportService = ReportService(report: ReportStub(true))
        sut.deleteAllReport { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(true)
            }
        }
    }
}
