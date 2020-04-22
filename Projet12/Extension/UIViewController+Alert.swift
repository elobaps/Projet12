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
    
    func presentAlertVerification(titre: String, message: String, completion: @escaping (Bool) -> Void) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oui", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion(false)
        }))
        present(alert, animated: true, completion: nil)
    }
}
