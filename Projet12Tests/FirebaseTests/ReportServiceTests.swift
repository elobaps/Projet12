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
            report.append(Report(dictionnary: ["": ""]))
        }
        
        func getReportsPublished(callback: @escaping (Result<[Report], Error>) -> Void) {
            report.append(Report(dictionnary: ["": ""]))
        }
        
        func deletedReport(identifier: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func deleteAllReports(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
    }
    
    // MARK: - Methods
    
    func createReport() -> Report {
        let dictionnary = [Constants.FStore.reportIdentifier: "", Constants.FStore.reportForUid: "", Constants.FStore.publishedReport: "", Constants.FStore.titleReport: "", Constants.FStore.textReport: "", Constants.FStore.timestampReport: nil]
        return Report(dictionnary: dictionnary as [String: Any])
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
