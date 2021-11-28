//
//  CVDProfileManager.swift
//  MySight
//
//  Created by Warren Gavin on 19/11/2021.
//

import SwiftUI

class CVDProfileManager: ObservableObject {
    var allProfiles: [CVDProfile] {
        CVDProfile.standardProfiles + UserDefaults.standard.savedProfiles()
    }

    @Published var activeProfile: CVDProfile = UserDefaults.standard.activeProfile {
        didSet {
            UserDefaults.standard.activeProfile = activeProfile
        }
    }
}


extension CVDProfileManager {
    func save(profile: CVDProfile) {
        activeProfile = profile
        UserDefaults.standard.save(profile: profile)
    }
}

