//
//  CVDAnalysisModel.swift
//  MySight
//
//  Created by Warren Gavin on 17/11/2021.
//

import Foundation

struct CVDAnalysisModel {
    private var severities: [CVD: Float] = [
        .deutan: 0.0,
        .protan: 0.0,
        .tritan: 0.0
    ]

    mutating func update(cvd: CVD, score closenessToNormal: Float) {
        severities[cvd]! += 1.0 - closenessToNormal
    }

    var probableCvd: CVD {
        severities
            .sorted { $0.1 > $1.1 }
            .map { $0.key }
            .first ?? .deutan
    }

    var probableSeverity: Float {
        let probableSeverity = severities
            .sorted { $0.1 > $1.1 }
            .map { $0.value }
            .first ?? 0.0

        return probableSeverity / Float(ConfusionLine.allTritans.count)
    }

    var eliminatedCvd: CVD? {
        .tritan
    }
}
