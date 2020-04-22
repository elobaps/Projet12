//
//  ShowReportViewController.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 19/04/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import UIKit

class ShowReportViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reportTextView: UITextView!
    
    // MARK: - Properties
    
    var reportRepresentable: Report?
    private let reportService: ReportService = ReportService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        updateReport()
    }
    
    // MARK: - Method
    
    func updateReport() {
        guard let reportRepresentable = reportRepresentable else { return }
        titleLabel.text = reportRepresentable.title
        reportTextView.text = reportRepresentable.text
        let date = reportRepresentable.timestamp
        timestampLabel.text = convertTimestampToString(timestamp: date)
    }
}
