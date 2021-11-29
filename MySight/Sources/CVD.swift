//
//  CVD.swift
//  MySight
//
//  Created by Warren Gavin on 17/11/2021.
//

import SwiftUI

enum CVD: UInt8, CaseIterable, Codable {
    case deutan
    case protan
    case tritan
}

extension CVD {
    var shortName: LocalizedStringKey {
        switch self {
        case .deutan:
            return "Deutan"

        case .protan:
            return "Protan"

        case .tritan:
            return "Tritan"
        }
    }

    var accessibilityAbbreviation: LocalizedStringKey {
        switch self {
        case .deutan:
            return "D"

        case .protan:
            return "P"

        case .tritan:
            return "T"
        }
    }

    var dichromatName: LocalizedStringKey {
        switch self {
        case .deutan:
            return "Deuteranopia"

        case .protan:
            return "Protanopia"

        case .tritan:
            return "Tritanopia"
        }
    }

    var anomalousTrichromatName: LocalizedStringKey {
        switch self {
        case .deutan:
            return "Deuteranomaly"

        case .protan:
            return "Protanomaly"

        case .tritan:
            return "Tritanomaly"
        }
    }
}
