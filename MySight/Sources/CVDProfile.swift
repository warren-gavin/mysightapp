//
//  CVDProfile.swift
//  MySight
//
//  Created by Warren Gavin on 18/11/2021.
//

import Foundation
import SwiftUI

struct CVDProfile: Codable, Equatable {
    let name: String
    let cvd: CVD
    let severity: Float
    let accessibilityAbbreviation: String?

    init(name: String, cvd: CVD, severity: Float, accessibilityAbbreviation: String? = nil) {
        self.name = name
        self.cvd = cvd
        self.severity = severity
        self.accessibilityAbbreviation = accessibilityAbbreviation
    }
}

extension CVDProfile: Identifiable {
    var id: String {
        "\(name)-\(cvd.dichromatName)-\(severity)"
    }
}

extension CVDProfile {
    static let standardProfiles = [
        CVDProfile(name: CVD.deutan.shortName.localized,
                   cvd: .deutan,
                   severity: 1.0,
                   accessibilityAbbreviation: CVD.deutan.accessibilityAbbreviation.localized),

        CVDProfile(name: CVD.protan.shortName.localized,
                   cvd: .protan,
                   severity: 1.0,
                   accessibilityAbbreviation: CVD.protan.accessibilityAbbreviation.localized),

        CVDProfile(name: CVD.tritan.shortName.localized,
                   cvd: .tritan,
                   severity: 1.0,
                   accessibilityAbbreviation: CVD.tritan.accessibilityAbbreviation.localized)

    ]
}
