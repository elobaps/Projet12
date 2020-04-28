//
//  UserServiceTests.swift
//  Projet12Tests
//
//  Created by Elodie-Anne Parquer on 24/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

@testable import Projet12
import XCTest

class UserServiceTests: XCTestCase {
    
    // MARK: - Helpers
    
    private class UserStub: UserType {
        
        private let isSuccess: Bool
        
        var user = [User]()
        
        var currentUID: String? { return isSuccess ? "AbCde34z2Abd" : nil }
        
        init(_ isSuccess: Bool) {
            self.isSuccess = isSuccess
        }
        
        func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void) {
            user.append(User(uid: "", email: "", firstName: "", lastName: "", type: ""))
        }
        
        func updateUserInformations(userFirstName: String, userLastName: String, email: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func getUsers(callback: @escaping (Result<[User], Error>) -> Void) {
            user.append(User(uid: "", email: "", firstName: "", lastName: "", type: ""))
        }
        
        func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void) {
            user.append(User(uid: "", email: "", firstName: "", lastName: "", type: ""))
        }
        
        func getUsersWithPatientFilter(callback: @escaping (Result<[User], Error>) -> Void) {
            user.append(User(uid: "", email: "", firstName: "", lastName: "", type: ""))
        }
        
        func deleteAccount(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
        
        func deletedUserData(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
    }
    
    // MARK: - Methods
    
    func createUser() -> User {
        return User(uid: "", email: "", firstName: "", lastName: "", type: "")
    }
    
    // MARK: - Tests
    
    func testCurrendUID_WhenUserIsConnected_ThenSouldReturnValue() {
        let sut: UserService = UserService(user: UserStub(true))
        let expectedUID: String = "AbCde34z2Abd"
        XCTAssertTrue(sut.currentUID! == expectedUID)
    }
    
    func testGetUserData_WhenLoadingData_ThenShouldReturnValue() {
        let sut: UserService = UserService(user: UserStub(true))
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
        let sut: UserService = UserService(user: UserStub(true))
        sut.updateUserInformations(userFirstName: "", userLastName: "", email: "") { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssert(true)
            }
        }
    }
    
    func testGetUsers_WhenLoadingData_ThenShouldReturnValue() {
        let sut: UserService = UserService(user: UserStub(true))
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
        let sut: UserService = UserService(user: UserStub(true))
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
        let sut: UserService = UserService(user: UserStub(true))
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
        let sut: UserService = UserService(user: UserStub(true))
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
        let sut: UserService = UserService(user: UserStub(true))
        sut.deletedUserData { (isSuccess) in
            if !isSuccess {
                XCTFail("Error")
                return
            } else {
                XCTAssertTrue(true)
            }
        }
    }
}
