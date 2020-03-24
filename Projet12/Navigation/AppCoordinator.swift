//
//  AppCoordinator.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 13/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

enum UserNavigation: String, CaseIterable, Codable {
    case patient
    case staff
    case family
    case none
}

final class AppCoordinator {
    private unowned var appDelegate: AppDelegate
    private let scenes = Scenes()
    //var userNavigation: UserNavigation = .none
    var userNavigation: UserNavigation = UserDefaults.standard.userNavigation
    private let authService: AuthService = AuthService()
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func start() {
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.makeKeyAndVisible()
        showPresenter()
    }
    
    private func showPresenter() {
        guard let window = appDelegate.window else { return }
        window.rootViewController = UIViewController()
        window.backgroundColor = .white
        authService.isUserConnected { (isConnected) in
            if !isConnected {
                self.showAuthentication()
            }
        }
     if authService.currentUID == nil { UserDefaults.standard.set(userNavigation: .none, forKey: UserDefaultsKeys.userNavigation.rawValue) }
              switch userNavigation {
              case .patient:
                  window.rootViewController = scenes.createPatientTabBarController()
              case .staff:
                  window.rootViewController = scenes.createStaffTabBarController()
              case .family:
                  window.rootViewController = scenes.createFamilyTabBarController()
              case .none:
                  showAuthentication()
              }
            
            //        case .patient:
        //            window.rootViewController = scenes.createPatientTabBarController()
    }
    
    private func showAuthentication() {
        let viewController = scenes.createAuthenticationController(delegate: self)
        viewController.modalPresentationStyle = .fullScreen
        appDelegate.window?.rootViewController?.present(viewController, animated: true)
    }
}

extension AppCoordinator: AuthenticationDataPassingDelegate {
    func authenticationSucceded(with userNavigation: UserNavigation) {
        self.userNavigation = userNavigation
        UserDefaults.standard.set(userNavigation: userNavigation, forKey: UserDefaultsKeys.userNavigation.rawValue)
        showPresenter()
    }
}
