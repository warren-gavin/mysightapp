//
//  CVDAnalysisViewModel.swift
//  MySight
//
//  Created by Warren Gavin on 16/11/2021.
//

import Foundation

class CVDAnalysisViewModel: ObservableObject {
    private let profileManager: CVDProfileManager
    private let userDefaults: UserDefaults

    private var model = CVDAnalysisModel()
    private var confusionLines: [ConfusionLine] = [
        .deutan_1, .protan_1, .tritan_1,
        .deutan_2, .protan_2, .tritan_2,
        .deutan_3, .protan_3, .tritan_3,
        .deutan_4, .protan_4, .tritan_4,
        .deutan_5, .protan_5, .tritan_5,
    ]
#if !targetEnvironment(simulator)
        .shuffled()
#endif

    var showIntro: Bool {
        return !userDefaults.bool(forKey: .showIntroKey)
    }

    var probableCvdAndSeverity: (CVD, Float) {
        model.probableCvdAndSeverity()
    }

//    var analysisComplete: Bool {
//        confusionLines.isEmpty
//    }

    init(profileManager: CVDProfileManager, userDefaults: UserDefaults = .standard) {
        self.profileManager = profileManager
        self.userDefaults = userDefaults
    }

    func introWasRead() {
        userDefaults.set(true, forKey: .showIntroKey)
        objectWillChange.send()
    }

    func loadNext(confusionLine: ConfusionLine?,
                  severity: Float) -> ConfusionLine? {
        let (next, remainder) = (confusionLines.first, Array(confusionLines.dropFirst()))
        confusionLines = remainder

        if let confusionLine = confusionLine {
            model.update(confusionLine: confusionLine, score: severity)
        }

        return next
    }

    func save(profile: CVDProfile, onSaved: @escaping () -> Void) {
        profileManager.save(profile: profile, onSaved: onSaved)
    }
}

private extension String {
    static let showIntroKey = "com.apokrupto.cvd-analysis-intro-shown"
}
