//
//  MySightApp.swift
//  MySight
//
//  Created by Warren Gavin on 07/11/2021.
//

import SwiftUI

@main
struct MySightApp: App {
    var body: some Scene {
        WindowGroup {
            contentView
        }
    }
}

extension MySightApp {
    var contentView: some View {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "AccentColor")
        return ContentView()
    }
}
