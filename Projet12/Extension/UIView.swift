//
//  UIViewController+View.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 23/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Update the design on the bar below navigation
    func configureNavSecondView() {
        DispatchQueue.main.async {
            self.layer.cornerRadius = 15
            self.layer.masksToBounds = false
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 2, height: 3.0)
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 4.0
        }
    }
}
