//
//  UserDefaults+UserNavigation.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 13/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case userNavigation
}

extension UserDefaults {
    func set(userNavigation: UserNavigation, forKey key: String) {
        guard let data = try? JSONEncoder().encode(userNavigation) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private func getUserNavigation(forKey key: String) -> UserNavigation {
        guard let data = UserDefaults.standard.data(forKey: key) else { return .none }
        guard let userNavigation = try? JSONDecoder().decode(UserNavigation.self, from: data) else { return .none }
        return userNavigation
    }
    
    var userNavigation: UserNavigation {
        return getUserNavigation(forKey: UserDefaultsKeys.userNavigation.rawValue)
    }
}
