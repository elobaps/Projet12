//
//  NotesPublishedPatientViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 16/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class ReportsPublishedViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var reportsTableView: UITableView! { didSet { reportsTableView.tableFooterView = UIView() }}
    @IBOutlet private weak var navSecondView: UIView!
    
    // MARK: - Properties
    
    var reports = [Report]()
    var reportRepresentable: Report?
    private let reportService: ReportService = ReportService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        navSecondView.configureNavSecondView()
        
        reportsTableView.register(UINib(nibName: Constants.Cell.notePublishedNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.notePublishedCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedReports()
    }
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let updateReportVC = segue.destination as? ShowReportViewController else { return }
        updateReportVC.reportRepresentable = reportRepresentable
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
        label.text = "Vous n'avez pas encore de comptes rendus"
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
        return 70
    }
}
