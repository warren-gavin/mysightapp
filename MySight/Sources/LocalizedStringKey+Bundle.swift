//
//  LocalizedStringKey+Bundle.swift
//  MySight
//
//  Created by Warren Gavin on 03/12/2021.
//

import SwiftUI

extension LocalizedStringKey {
    var localized: String {
        let description = "\(self)"
        let components = description
            .components(separatedBy: "key: \"")
            .map {
                $0.components(separatedBy: "\",")
            }

        return components[1][0].localizedString()
    }
}

private extension String {
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
