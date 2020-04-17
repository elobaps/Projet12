//
//  UIViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 10/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureNavigationBar() {
        if #available(iOS 13.0, *) {
            let navigationBar = navigationController?.navigationBar
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(red: 24/255.0, green: 150/255.0, blue: 157/255.0, alpha: 1.0)
            navBarAppearance.shadowColor = .clear
            navigationBar?.scrollEdgeAppearance = navBarAppearance
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
    }
}
