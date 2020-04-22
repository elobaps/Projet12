//
//  PatientsListViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 21/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class PatientListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var patientsTableView: UITableView! { didSet { patientsTableView.tableFooterView = UIView() }}
    
    // MARK: - Properties
    
    var users = [User]()
    var userRepresentable: User?
    private let reportService: ReportService = ReportService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
         super.viewDidLoad()
         configureNavigationBar()
         
          patientsTableView.register(UINib(nibName: Constants.Cell.notePublishedNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.notePublishedCellIdentifier)
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        loadedUsers()
        patientsTableView.reloadData()
     }
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          guard let updateUserVC = segue.destination as? ShowUserViewController else { return }
              updateUserVC.userRepresentable = userRepresentable
      }
    
    private func loadedUsers() {
          reportService.getUsersWithPatientFilter { (result) in
              switch result {
              case .success(let users):
                  DispatchQueue.main.async {
                      self.users = users
                      self.patientsTableView.reloadData()
                  }
              case .failure(let error):
                  self.presentAlert(titre: "Erreur", message: "Le chargement des utilisateurs a échoué")
                  print(error)
              }
          }
      }
}

// MARK: - UITableViewDataSource

extension PatientListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.notePublishedCellIdentifier, for: indexPath) as? NotePublishedTableViewCell else { return UITableViewCell() }
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        userRepresentable = user
        performSegue(withIdentifier: Constants.Segue.showToUserSegue, sender: nil)
    }
}

// MARK: - UITableViewDelegate

/// extension that manages the table view and allows the display of a message when the list is empty and the deletion of a cell
extension PatientListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Ajouter des notes à votre liste"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return users.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // cell's height
        return 60
    }
}
