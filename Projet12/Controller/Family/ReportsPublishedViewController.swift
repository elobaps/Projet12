//
//  NotesPublishedPatientViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 16/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class ReportsPublishedViewController: UIViewController {
    
    @IBOutlet weak var reportsTableView: UITableView!
    
    var reports = [Report]()
    var reportRepresentable: Report?
    private let reportService: ReportService = ReportService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        reportsTableView.register(UINib(nibName: Constants.Cell.notePublishedNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.notePublishedCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedReports()
    }
    
    private func loadedReports() {
        reportService.getReportsPublished { (result) in
            switch result {
            case .success(let reports):
                DispatchQueue.main.async {
                    self.reports = reports
                    self.reportsTableView.reloadData()
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des notes a échoué")
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ReportsPublishedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let report = reports[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.notePublishedCellIdentifier, for: indexPath) as? NotePublishedTableViewCell else { return UITableViewCell() }
        cell.report = report
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = reports[indexPath.row]
        reportRepresentable = report
        performSegue(withIdentifier: Constants.Segue.showToReportSegue, sender: nil)
    }
}

// MARK: - UITableViewDelegate

/// extension that manages the table view and allows the display of a message when the list is empty and the deletion of a cell
extension ReportsPublishedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Ajouter des notes à votre liste"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return reports.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // cell's height
        return 91
    }
}
