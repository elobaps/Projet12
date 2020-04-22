//
//  UIViewController+SegmentedControl.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 19/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func configureSegmentedControl() {
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        
        let color: UIColor = UIColor.white
        let fontCustomized: UIFont = UIFont(name: "HelveticaNeue-Bold", size: 16)!
        
        let withAttributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: fontCustomized]
        
        UISegmentedControl.appearance().setTitleTextAttributes(withAttributes, for: .normal)
        
    }
}
