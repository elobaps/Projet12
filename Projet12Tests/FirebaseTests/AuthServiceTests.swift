//
//  AuthFirestoreTests.swift
//  Projet12Tests
//
//  Created by Elodie-Anne Parquer on 23/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

@testable import Projet12
import XCTest

class AuthServiceTests: XCTestCase {
    
    // MARK: - Helpers
    
    private class AuthStub: AuthType {
        
        private let isSuccess: Bool
        
        var currentUID: String? { return isSuccess ? "AbCde34z2Abd" : nil }
        
        init(_ isSuccess: Bool) {
            self.isSuccess = isSuccess
        }
        
        func signIn(type: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func signUp(type: String, userFirstName: String, userLastName: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        func signUpFamily(type: String, userFirstName: String, userLastName: String, email: String, password: String, patientUid: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func signOut(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func isUserConnected(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
    }
    
    // MARK: - Helpers
    
    func testCurrendUID_WhenUserIsConnected_ThenSouldReturnValue() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectedUID: String = "AbCde34z2Abd"
        XCTAssertTrue(sut.currentUID! == expectedUID)
    }
    
    func testCurrendUID_WhenUserIsDisconnected_ThenSouldReturnNilValue() {
        let sut: AuthService = AuthService(auth: AuthStub(false))
        let expectedUID: String? = nil
        XCTAssertTrue(sut.currentUID == expectedUID, "")
    }
    
    func testCurrendUID_WhenUserIsSignUp_ThenSouldReturnValue() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let newUID: String = "Bc3456hDujlo"
        sut.signUp(type: "staff", userFirstName: "Elo", userLastName: "Parquer", email: "ea.parquer@gmail.com", password: "123456") { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(sut.currentUID! != newUID)
            }
        }
    }
    
    func testCurrendUID_WhenUserIsSignUpFamily_ThenSouldReturnValue() {
           let sut: AuthService = AuthService(auth: AuthStub(true))
           let newUID: String = "Bc3456hDujlo"
           sut.signUpFamily(type: "staff", userFirstName: "Elo", userLastName: "Parquer", email: "ea.parquer@gmail.com", password: "123456", patientUid: "") { (isSuccess) in
               if !isSuccess {
                   XCTFail("Error")
                   return
               } else {
                   XCTAssertTrue(sut.currentUID! != newUID)
               }
           }
       }
    
    func testCurrendUID_WhenUserIsSignIn_ThenSouldReturnValue() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectedUID: String = "AbCde34z2Abd"
        sut.signIn(type: "staff", email: "ea.parquer@gmail.com", password: "123456") { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(sut.currentUID! == expectedUID)
            }
        }
    }
    
    func testCurrendUID_WhenUserIsSignOut_ThenSouldReturnValue() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectedUID: String = "AbCde34z2Abd"
        sut.signOut { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(sut.currentUID! == expectedUID)
            }
        }
    }
}
