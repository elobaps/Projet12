//
//  UpdateReportViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class UpdateReportViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var reportTextView: UITextView!
    @IBOutlet private weak var publishedSwitch: UISwitch!
    @IBOutlet private weak var usersPickerView: UIPickerView!
    
    var reportRepresentable: Report?
    var reports = [Report]()
    private let reportService: ReportService = ReportService()
    private let userService: UserService = UserService()
    var users = [User]()
    var selectedRow: Int?
    lazy var userId: String = {
        if self.reportRepresentable != nil {
            return self.reportRepresentable?.forUid ?? ""
        }
        return String()
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        updateReport()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedUsers()
    }
    
    // MARK: - Actions
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        guard timestampLabel.text != nil else { return }
        guard let title = titleTextField.text else { return }
        guard let reportText = reportTextView.text else { return }
        //        guard userId != String() else { return }
        let publishedReport = publishedSwitch.isOn
        guard userId != String() else {
            presentAlert(titre: "Attention", message: "Veuillez renseigner un utilisateur à qui attribué le compte rendu")
            return
        }
        self.reportService.savedReport(identifier: self.reportRepresentable?.identifier, forUid: self.userId, title: title, text: reportText, timestamp: 0, published: publishedReport) { (isSuccess) in
            if isSuccess {
                self.performSegue(withIdentifier: "unwindToReportViewController", sender: nil)
            } else {
                self.presentAlert(titre: "Erreur", message: "L'enregistrement a échoué")
            }
        }
    }
    
    // MARK: - Methods
    
    private func updateReport() {
        guard let reportRepresentable = reportRepresentable else { return }
        titleTextField.text = reportRepresentable.title
        reportTextView.text = reportRepresentable.text
        let date = reportRepresentable.timestamp
        timestampLabel.text = convertTimestampToString(timestamp: date ?? 0)
        publishedSwitch.isSelected = reportRepresentable.published ?? true
        
        if reportRepresentable.published == true {
            publishedSwitch.setOn(true, animated: false)
        } else {
            publishedSwitch.setOn(false, animated: false)
        }
    }
    
    private func loadedUsers() {
        userService.getUsersWithFamilyFilter { (result) in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users
                    self.usersPickerView.reloadAllComponents()
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des utilisateurs a échoué")
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension UpdateReportViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return users.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(users[row].firstName) \(users[row].lastName)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userId = users[row].uid
        selectedRow = row
    }
}
