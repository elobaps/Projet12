//
//  AppDelegate.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 10/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let firestoreService = AuthService()
//        firestoreService.signOut { (_) in
//
//        }
//
        FirebaseApp.configure()
        
        appCoordinator = AppCoordinator(appDelegate: self)
        appCoordinator?.start()
        
//        let db = Firestore.firestore()
//        print(db)
        
        return true
    }
}
