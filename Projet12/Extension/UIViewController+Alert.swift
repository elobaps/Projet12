//
//  UIViewController+Alert.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 17/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

// MARK: - Present alert

extension UIViewController {
    
    /// Method that manage alerts which will be used
    func presentAlert(titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
