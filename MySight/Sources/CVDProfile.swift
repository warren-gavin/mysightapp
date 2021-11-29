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

extension CVDProfile {
    static let standardProfiles = [
        CVDProfile(name: CVD.deutan.shortName.str, cvd: .deutan, severity: 1.0, accessibilityAbbreviation: CVD.deutan.accessibilityAbbreviation.str),
        CVDProfile(name: CVD.protan.shortName.str, cvd: .protan, severity: 1.0, accessibilityAbbreviation: CVD.protan.accessibilityAbbreviation.str),
        CVDProfile(name: CVD.tritan.shortName.str, cvd: .tritan, severity: 1.0, accessibilityAbbreviation: CVD.tritan.accessibilityAbbreviation.str)
    ]
}

extension String {
    func localizedString(locale: Locale = .current) -> String {
        let language = locale.languageCode
        let bundle: Bundle = {
            guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
                return .main
            }

            return Bundle(path: path)!
        }()

        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}

extension LocalizedStringKey {
    var str: String {
        let description = "\(self)"
        let components = description
            .components(separatedBy: "key: \"")
            .map {
                $0.components(separatedBy: "\",")
            }

        return components[1][0].localizedString()
    }
}
