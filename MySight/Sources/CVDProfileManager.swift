//
//  CVDProfileManager.swift
//  MySight
//
//  Created by Warren Gavin on 19/11/2021.
//

import SwiftUI

class CVDProfileManager: ObservableObject {
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
    func save(profile: CVDProfile) {
        activeProfile = profile
        userDefaults.save(profile: profile)
    }

    func remove(profile: CVDProfile) {
        userDefaults.remove(profile: profile)
    }
}

