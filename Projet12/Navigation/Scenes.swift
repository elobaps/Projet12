//
//  Scenes.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 13/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class Scenes {
    private let authenticationSB = UIStoryboard(name: "Authentication", bundle: Bundle(for: Scenes.self))
    private let patientSB = UIStoryboard(name: "Patient", bundle: Bundle(for: Scenes.self))
    private let familySB = UIStoryboard(name: "Family", bundle: Bundle(for: Scenes.self))
    private let staffSB = UIStoryboard(name: "Staff", bundle: Bundle(for: Scenes.self))
}

extension Scenes {
    func createPatientTabBarController() -> UIViewController {
        let viewController = patientSB.instantiateViewController(withIdentifier: "PatientTabBarController")
        return viewController
    }
}

extension Scenes {
    func createFamilyTabBarController() -> UIViewController {
        let viewController = familySB.instantiateViewController(withIdentifier: "FamilyTabBarController")
        return viewController
    }
}

extension Scenes {
    func createStaffTabBarController() -> UIViewController {
        let viewController = staffSB.instantiateViewController(withIdentifier: "StaffTabBarController")
        return viewController
    }
}

protocol AuthenticationDataPassingDelegate: class {
    func authenticationSucceded(with userNavigation: UserNavigation)
}

extension Scenes {
    func createAuthenticationController(delegate: AuthenticationDataPassingDelegate?) -> UIViewController {
        guard let viewController = authenticationSB.instantiateViewController(withIdentifier: "AuthenticationController") as? SignInViewController else { return UIViewController() }
        viewController.delegate = delegate
        return viewController
    }
}
