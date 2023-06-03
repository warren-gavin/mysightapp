//
//  CVDProfileManager.swift
//  MySight
//
//  Created by Warren Gavin on 19/11/2021.
//

import SwiftUI

final class CVDProfileManager: ObservableObject {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var standardProfiles: [CVDProfile] {
        CVDProfile.standardProfiles
    }

    var savedProfiles: [CVDProfile] {
        userDefaults.savedProfiles()
    }

    var savedProfilesExist: Bool {
        !userDefaults.savedProfiles().isEmpty
    }

    @Published var activeProfile: CVDProfile = UserDefaults.standard.activeProfile {
        didSet {
            userDefaults.activeProfile = activeProfile
        }
    }
}

extension CVDProfileManager {
    func save(profile: CVDProfile, onSaved: (() -> Void)? = nil) {
        if userDefaults.save(profile: profile) {
            activeProfile = profile
            onSaved?()
        }
    }

    func remove(profile: CVDProfile) {
        guard let idx = userDefaults.remove(profile: profile) else {
            return
        }

        let saved = savedProfiles
        let defaultProfile = CVDProfile.standardProfiles[0]

        if saved.isEmpty {
            activeProfile = defaultProfile
        }
        else {
            activeProfile = saved[safe: min(saved.count - 1, idx)] ?? defaultProfile
        }
    }
}

