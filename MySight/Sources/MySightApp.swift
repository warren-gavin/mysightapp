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

        return V()
    }
}

struct V: View {
    @State var severity: Float = 0.0

    var body: some View {
        VStack {
            ConfusionLineArrayView(cvd: .deutan, severity: $severity)
                .padding(.top, 60)
                .padding(.bottom, 20)

            Slider(value: $severity, in: 0...1)
        }
        .padding(.horizontal, 24)
    }
}
