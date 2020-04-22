//
//  UpdateReportViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class UpdateReportViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var publishedSwitch: UISwitch!
    @IBOutlet weak var usersPickerView: UIPickerView!
    
    var reportRepresentable: Report?
    var reports = [Report]()
    private let reportService: ReportService = ReportService()
    var users = [User]()
    var user = String()
    
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard timestampLabel.text != nil else { return }
        guard let title = titleTextField.text else { return }
        guard let reportText = reportTextView.text else { return }
        let publishedReport = publishedSwitch.isOn
        reportService.savedReport(identifier: reportRepresentable?.identifier, forUid: user, title: title, text: reportText, timestamp: 0, published: publishedReport) { (isSuccess) in
            if isSuccess {
                self.performSegue(withIdentifier: "unwindToReportViewController", sender: nil)
            } else {
                self.presentAlert(titre: "Erreur", message: "L'enregistrement a échoué")
            }
        }
    }
    
    // MARK: - Methods
    
    func updateReport() {
        guard let reportRepresentable = reportRepresentable else { return }
        titleTextField.text = reportRepresentable.title
        reportTextView.text = reportRepresentable.text
        let date = reportRepresentable.timestamp
        timestampLabel.text = convertTimestampToString(timestamp: date)
        publishedSwitch.isSelected = reportRepresentable.published
//        usersPickerView.selectRow(reportRepresentable.forUid, inComponent: 0, animated: false)
        
        //        let userIndex = usersPickerView.selectedRow(inComponent: 0)
        //        let test = users[userIndex].uid
        //        if user != nil {
        //            reportRepresentable.forUid = user
        //        }
        
        if reportRepresentable.published == true {
            publishedSwitch.setOn(true, animated: false)
        } else {
            publishedSwitch.setOn(false, animated: false)
        }
        
    }
    
    private func loadedUsers() {
        reportService.getUsersWithFamilyFilter { (result) in
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
        user = users[row].uid

    }
}
