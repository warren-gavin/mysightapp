//
//  CVDProfile+Strings.swift
//  MySight
//
//  Created by Warren Gavin on 05/12/2021.
//

import SwiftUI

extension CVDProfile {
    var description: String {
        switch severity {
        case 0.99...:
            return cvd.dichromatName.localized

        default:
            return String(format: NSLocalizedString("%lld%% %@", comment: "'"), Int(severity * 100), cvd.anomalousTrichromatName.localized)
        }
    }
}
