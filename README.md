# UniHP

Supports: iOS 11 and above

> using of Firebase for data persistence for patient and medical staff notes and reports and user authentication

## Introduction:

UniHP is an app for psychiatric hospitals and precisely for three very distinct profiles within them : patients, medical staff and families.
It breaks down into 3 tabBar with several features:

* a notes's system for the patient with optional publication of these to medical staff
* a patient profile for updating their information
* an access to patient ids for medical staff
* a reporting system for medical staff to share daily news from patients to their families

## API:

This app uses the following APIS :

* Forismatic
* OpenWeatherMap

## Getting started:

To test this application, you need to use API key for OpenWeatherMap.

In supporting files's folder, you need to create a file ApiConfig.swift.
It should contain the following informations :

```
struct ApiConfig {
  static let openWeatherMapApiKey = "yourApiKey"
}
```

## Dependencies:

* SwiftLint - A tool to enforce Swift style and conventions. [SwiftLint documentation.](https://github.com/realm/SwiftLint "SwiftLint documentation.")
* Firebase Cloud Firestore stores and synchronizes data between users and devices. [Firebase documentation.](https://github.com/firebase "Firebase documentation.")
* IQKeyboardManager manages issues keyboard on all orientations. [IQKeyboardManager documentation.](https://github.com/hackiftekhar/IQKeyboardManager "IQKeyboardManager documentation.")
