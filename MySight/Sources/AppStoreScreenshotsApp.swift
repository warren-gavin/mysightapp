//
//  AppStoreScreenshotsApp.swift
//  MySight
//
//  Created by Warren Gavin on 23/01/2022.
//

import SwiftUI

@main
struct AppStoreScreenshotsApp: App {
    var body: some Scene {
        WindowGroup {
            contentView
        }
    }
}

extension AppStoreScreenshotsApp {
    var contentView: some View {
        UIView.setAnimationsEnabled(false)
        UserDefaults.standard.removeAllProfiles()
        UserDefaults.standard.set(true, forKey: "com.apokrupto.cvd-analysis-intro-shown")
        UIView
            .appearance(whenContainedInInstancesOf: [UIAlertController.self])
            .tintColor = UIColor(named: "AccentColor")

        return ContentView()
    }
}
