//
//  ReportsNoteViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 09/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

final class ReportsViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var reportsTableView: UITableView! { didSet { reportsTableView.tableFooterView = UIView() }}
    @IBOutlet private weak var navSecondView: UIView!
    
    // MARK: - Properties
    
    var reports = [Report]()
    var reportRepresentable: Report?
    private let reportService: ReportService = ReportService()
    var selectedSegue: Int = Int()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        navSecondView.configureNavSecondView()
        
        reportsTableView.register(UINib(nibName: Constants.Cell.noteNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.noteCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedReports()
    }
    
    // MARK: - Actions
    
    @IBAction private func unwindToReportViewController(_ segue: UIStoryboardSegue) {}
    
    @IBAction private func addReportButtonTapped(_ sender: Any) {
        selectedSegue = 1
        performSegue(withIdentifier: Constants.Segue.updateReportSegue, sender: nil)
    }
    
    @IBAction private func clerButtonTapped(_ sender: Any) {
        reportService.deleteAllReport { (isSuccess) in
            if isSuccess {
                self.loadedReports()
            } else {
                self.presentAlert(titre: "Erreur", message: "La suppression a échoué")
            }
        }
    }
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let updateReportVC = segue.destination as? UpdateReportViewController else { return }
        if selectedSegue == 2 {
            updateReportVC.reportRepresentable = reportRepresentable
        }
    }
    
    private func loadedReports() {
        reportService.getReports { (result) in
            switch result {
            case .success(let reports):
                DispatchQueue.main.async {
                    self.reports = reports
                    self.reportsTableView.reloadData()
                }
            case .failure(let error):
                self.presentAlert(titre: "Erreur", message: "Le chargement des comptes rendus a échoué")
                print(error)
            }
        }
    }
    
    private func deletedReport(identifier: String) {
         reportService.deletedReport(identifier: identifier) { (isSuccess) in
             if !isSuccess {
                 self.presentAlert(titre: "Erreur", message: "La suppression a échoué")
             }
         }
     }
}

// MARK: - UITableViewDataSource

extension ReportsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let report = reports[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.noteCellIdentifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }
        cell.report = report
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = reports[indexPath.row]
        selectedSegue = 2
        reportRepresentable = report
        performSegue(withIdentifier: Constants.Segue.updateReportSegue, sender: nil)
    }
    
}

// MARK: - UITableViewDelegate

/// extension that manages the table view and allows the display of a message when the list is empty and the deletion of a cell
extension ReportsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deletedReport(identifier: reports[indexPath.row].identifier ?? "")
            reports.remove(at: indexPath.row)
            reportsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            reportsTableView.reloadData()
        }
    }
    
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
