//
//  UserService.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 24/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

protocol UserType {
    var currentUID: String? { get }
    func getUsers(callback: @escaping (Result<[User], Error>) -> Void)
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void)
    func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void)
    func getUsersWithPatientFilter(callback: @escaping (Result<[User], Error>) -> Void)
    func updateUserInformations(userFirstName: String, userLastName: String, email: String, callback: @escaping (Bool) -> Void)
    func deleteAccount(callback: @escaping (Bool) -> Void)
    func deletedUserData(callback: @escaping (Bool) -> Void)
}

final class UserService {
    private let user: UserType
    var currentUID: String? { return user.currentUID}
    
    init(user: UserType = UserFirestore()) {
        self.user = user
    }
    
    func getUsers(callback: @escaping (Result<[User], Error>) -> Void) {
        user.getUsers(callback: callback)
    }
    
    func getUserData(with uid: String, callback: @escaping (Result<[User], Error>) -> Void) {
        user.getUserData(with: uid, callback: callback)
    }
    
    func getUsersWithFamilyFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        user.getUsersWithFamilyFilter(callback: callback)
    }
    
    func getUsersWithPatientFilter(callback: @escaping (Result<[User], Error>) -> Void) {
        user.getUsersWithPatientFilter(callback: callback)
    }
    
    func updateUserInformations(userFirstName: String, userLastName: String, email: String, callback: @escaping (Bool) -> Void) {
        user.updateUserInformations(userFirstName: "", userLastName: "", email: "", callback: callback)
    }
    func deleteAccount(callback: @escaping (Bool) -> Void) {
        user.deleteAccount(callback: callback)
    }
    
    func deletedUserData(callback: @escaping (Bool) -> Void) {
        user.deletedUserData(callback: callback)
    }
}
