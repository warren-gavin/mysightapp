//
//  UserDefaults+AppStoreScreenshots.swift
//  AppStoreScreenshots
//
//  Created by Warren Gavin on 23/01/2022.
//

import Foundation

extension UserDefaults {
    func removeAllProfiles() {
        set(nil, forKey: "com.apokrupto.mysight.profiles")
    }
}
