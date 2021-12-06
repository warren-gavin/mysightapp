//
//  UserDefaults+CVDProfile.swift
//  MySight
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
            return allProfiles.first { $0.name == profileName } ?? defaultProfile
        }

        set {
            set(newValue.name, forKey: .activeProfileKeyPath)
        }
    }

    func save(profile: CVDProfile) {
        var savedProfiles = savedProfiles()

        savedProfiles.removeAll { element in
            profile.name == element.name
        }

        savedProfiles.append(profile)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedProfiles) {
            set(encoded, forKey: .profilesKeyPath)
        }
    }

    func remove(profile: CVDProfile) -> Int? {
        guard let idx = savedProfiles().firstIndex(of: profile) else {
            return nil
        }

        let remainingProfiles = savedProfiles().filter { $0 != profile }

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(remainingProfiles) {
            set(encoded, forKey: .profilesKeyPath)
        }

        return idx
    }
}

private extension UserDefaults {
    static let appKey = "com.apokrupto.mysight"
}

private extension String {
    static let profilesKeyPath = "\(UserDefaults.appKey).profiles"
    static let activeProfileKeyPath = "\(UserDefaults.appKey).active-profile"
}
