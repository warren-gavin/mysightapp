//
//  UserDefaults+CVDProfile.swift
//  MySightPOC
//
//  Created by Warren Gavin on 18/11/2021.
//

import Foundation

extension UserDefaults {
    func savedProfiles() -> [CVDProfile] {
        guard let profileData = object(forKey: .profilesKeyPath) as? Data else {
            removeObject(forKey: .profilesKeyPath)
            return []
        }

        let decoder = JSONDecoder()
        if let profiles = try? decoder.decode([CVDProfile].self, from: profileData) {
            return profiles
        }

        return []
    }

    var activeProfile: CVDProfile {
        get {
            let defaultProfile = CVDProfile.standardProfiles.first!

            guard let profileName = string(forKey: .activeProfileKeyPath) else {
                return defaultProfile
            }

            let allProfiles = savedProfiles() + CVDProfile.standardProfiles
            if let match = allProfiles.first(where: { $0.name == profileName }) {
                return match
            }

            return defaultProfile
        }

        set {
            set(newValue.name, forKey: .activeProfileKeyPath)
        }
    }

    func save(profile: CVDProfile) {
        var savedProfiles = savedProfiles()
        savedProfiles.append(profile)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedProfiles) {
            set(encoded, forKey: .profilesKeyPath)
        }
    }
}

private extension UserDefaults {
    static let appKey = "com.apokrupto.mysight"
}

private extension String {
    static let profilesKeyPath = "\(UserDefaults.appKey).profiles"
    static let activeProfileKeyPath = "\(UserDefaults.appKey).active-profile"
}
