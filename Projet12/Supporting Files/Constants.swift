//
//  Constants.swift
//  Projet12
//
//  Created by Elodie-Anne Parquer on 17/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

struct Constants {
    
    struct Segue {
        static let updateNoteSegue = "SegueToUpdateNote"
        static let backToNoteResume = "SegueToNotesResume"
        static let showNoteSegue = "SegueToShowNote"
        static let updateReportSegue = "SegueToUpdateReport"
        static let showToReportSegue = "SegueToShowReport"
        static let showToUserSegue = "SegueToShowUser"
    }
    
    struct FStore {
        static let userCollectionName = "users"
        static let userFirstNameField = "userFirstName"
        static let userLastNameField = "userLastName"
        static let userEmailField = "userEmail"
        static let userPasswordField = "userPassword"
        static let userType = "userType"
        static let userUID = "uid"
        static let userPatientUID = "patientUid"
        static let noteCollectionName = "notes"
        static let identifier = "identifier"
        static let noteFirstName = "firstName"
        static let noteLastName = "lastName"
        static let titleNote = "titleNote"
        static let textNote = "textNote"
        static let publishedNote = "publishedNote"
        static let timestamp = "timestamp"
        static let reportCollectionName = "reports"
        static let reportIdentifier = "reportIdentifier"
        static let reportForUid = "reportForUid"
        static let titleReport = "titleReport"
        static let textReport = "reportTextNote"
        static let publishedReport = "publishedReport"
        static let timestampReport = "reportTimestamp"
    }
    
    struct Cell {
        static let noteCellIdentifier = "NoteCell"
        static let notePublishedCellIdentifier = "NotePublishedCell"
        static let noteNibName = "NoteTableViewCell"
        static let notePublishedNibName = "NotePublishedTableViewCell"
    }
}
