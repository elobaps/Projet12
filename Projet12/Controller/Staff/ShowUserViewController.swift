//
//  ShowUserViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 21/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class ShowUserViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var uidLabel: UILabel!
    
    // MARK: - Properties
    
    var users = [User]()
    var userRepresentable: User?
    private let reportService: ReportService = ReportService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        updateUser()
    }
    
    // MARK: - Method
    
    private func updateUser() {
        guard let userRepresentable = userRepresentable else { return }
        emailLabel.text = userRepresentable.email
        uidLabel.text = userRepresentable.uid
        nameLabel.text = "\(userRepresentable.firstName) \(userRepresentable.lastName)"
    }
}
