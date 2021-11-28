//
//  CVDAnalysisModel.swift
//  MySight
//
//  Created by Warren Gavin on 17/11/2021.
//

import Foundation

struct CVDAnalysisModel {
    private var scores: [CVD: Float] = [
        .deutan: 0.0,
        .protan: 0.0,
        .tritan: 0.0
    ]

    mutating func update(confusionLine: ConfusionLine, score: Float) {
        scores[confusionLine.cvd]! += 1.0 - score
    }

    func probableCvdAndSeverity() -> (CVD, Float) {
        let probable = scores.sorted {
            $0.1 > $1.1
        }.first!

        return (probable.key, probable.value / Float(ConfusionLine.allTritans.count))
    }
}
