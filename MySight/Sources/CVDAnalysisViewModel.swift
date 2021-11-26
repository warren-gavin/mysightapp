//
//  CVDAnalysisViewModel.swift
//  MySightPOC
//
//  Created by Warren Gavin on 16/11/2021.
//

import Foundation

class CVDAnalysisViewModel {
    private let profileManager: CVDProfileManager
    private var model = CVDAnalysisModel()
    private var confusionLines: [ConfusionLine] = [
        .deutan_1, .protan_1, .tritan_1,
        .deutan_2, .protan_2, .tritan_2,
        .deutan_3, .protan_3, .tritan_3,
        .deutan_4, .protan_4, .tritan_4,
        .deutan_5, .protan_5, .tritan_5
    ].shuffled()

    var probableCvdAndSeverity: (CVD, Float) {
        model.probableCvdAndSeverity()
    }

    var analysisComplete: Bool {
        confusionLines.isEmpty
    }

    init(profileManager: CVDProfileManager) {
        self.profileManager = profileManager
    }

    func loadNext(confusionLine: ConfusionLine?,
                  severity: Float) -> ConfusionLine? {
        let (first, remainder) = (confusionLines.first,
                                  Array(confusionLines.dropFirst()))
        confusionLines = remainder

        if let confusionLine = confusionLine {
            model.update(confusionLine: confusionLine, score: severity)
        }

        return first
    }

    func save(profile: CVDProfile) {
        profileManager.save(profile: profile)
    }
}
