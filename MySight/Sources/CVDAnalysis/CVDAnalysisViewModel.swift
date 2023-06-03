//
//  CVDAnalysisViewModel.swift
//  MySight
//
//  Created by Warren Gavin on 16/11/2021.
//

import Foundation

final class CVDAnalysisViewModel: ObservableObject {
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

    private lazy var numberOfConfusionLines = confusionLines.count

    var showIntro: Bool {
        return !userDefaults.bool(forKey: .showIntroKey)
    }

    var probableCvd: CVD {
        model.probableCvd
    }

    var probableSeverity: Float {
        model.probableSeverity
    }

    var completionProgress: Double {
        Double(numberOfConfusionLines - confusionLines.count) / Double(numberOfConfusionLines + 1)
    }

    init(profileManager: CVDProfileManager, userDefaults: UserDefaults = .standard) {
        self.profileManager = profileManager
        self.userDefaults = userDefaults

#if !targetEnvironment(simulator)
        self.confusionLines.shuffle()
#endif
    }

    func introWasRead() {
        userDefaults.set(true, forKey: .showIntroKey)
        objectWillChange.send()
    }

    func loadNext(confusionLine: ConfusionLine?, severity: Float) -> ConfusionLine? {
        let (next, remainder) = (confusionLines.first, Array(confusionLines.dropFirst()))
        confusionLines = remainder

        if let confusionLine {
            model.update(cvd: confusionLine.cvd, score: severity)
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
