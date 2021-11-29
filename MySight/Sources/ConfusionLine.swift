//
//  ConfusionLine.swift
//  MySight
//
//  Created by Warren Gavin on 12/11/2021.
//

import SwiftUI

struct ConfusionLine: Hashable {
    let cvd: CVD
    let values: [UInt32]
}

extension ConfusionLine {
    var size: Int {
        values.count
    }
    
    var colors: [Color] {
        values.map { Color(hex: $0) }
    }
}

extension ConfusionLine {
    static let deutan_1 = ConfusionLine(cvd: .deutan, values: deutan_confusion_line_1)
    static let deutan_2 = ConfusionLine(cvd: .deutan, values: deutan_confusion_line_2)
    static let deutan_3 = ConfusionLine(cvd: .deutan, values: deutan_confusion_line_3)
    static let deutan_4 = ConfusionLine(cvd: .deutan, values: deutan_confusion_line_4)
    static let deutan_5 = ConfusionLine(cvd: .deutan, values: deutan_confusion_line_5)
    
    static let allDeutans = [deutan_1, deutan_2, deutan_3, deutan_4, deutan_5]
    
    static let protan_1 = ConfusionLine(cvd: .protan, values: protan_confusion_line_1)
    static let protan_2 = ConfusionLine(cvd: .protan, values: protan_confusion_line_2)
    static let protan_3 = ConfusionLine(cvd: .protan, values: protan_confusion_line_3)
    static let protan_4 = ConfusionLine(cvd: .protan, values: protan_confusion_line_4)
    static let protan_5 = ConfusionLine(cvd: .protan, values: protan_confusion_line_5)
    
    static let allProtans = [protan_1, protan_2, protan_3, protan_4, protan_5]
    
    static let tritan_1 = ConfusionLine(cvd: .tritan, values: tritan_confusion_line_1)
    static let tritan_2 = ConfusionLine(cvd: .tritan, values: tritan_confusion_line_2)
    static let tritan_3 = ConfusionLine(cvd: .tritan, values: tritan_confusion_line_3)
    static let tritan_4 = ConfusionLine(cvd: .tritan, values: tritan_confusion_line_4)
    static let tritan_5 = ConfusionLine(cvd: .tritan, values: tritan_confusion_line_5)
    
    static let allTritans = [tritan_1, tritan_2, tritan_3, tritan_4, tritan_5]
}

private let deutan_confusion_line_1: [UInt32] = [
    0xd8007f,
    0xc73d7e,
    0xb4567d,
    0x9e687c,
    0x83787b,
    0x5f857a,
    0x009079
]

private let deutan_confusion_line_2: [UInt32] = [
    0xfe93be,
    0xeba2bd,
    0xd5afbc,
    0xbbbbbb,
    0x9cc6ba,
    0x71d0b9,
    0x00dab8
]

private let deutan_confusion_line_3: [UInt32] = [
    0xee00e3,
    0xdc44e2,
    0xc760e1,
    0xaf74e1,
    0x9185e0,
    0x6993e0,
    0x00a0df
]

private let deutan_confusion_line_4: [UInt32] = [
    0xfed28a,
    0xeeda89,
    0xdbe288,
    0xc6ea87,
    0xaef186,
    0x90f885,
    0x68fe84
]

private let deutan_confusion_line_5: [UInt32] = [
    0x97fee5,
    0xaef9e5,
    0xc2f4e6,
    0xd3eee6,
    0xe3e8e6,
    0xf1e2e7,
    0xfedce7
]

private let protan_confusion_line_1: [UInt32] = [
    0xfe5a7a,
    0xeb627a,
    0xd5697a,
    0xbb707b,
    0x9c767b,
    0x717c7b,
    0x00827b
]

private let protan_confusion_line_2: [UInt32] = [
    0xfeb0bb,
    0xebb4bb,
    0xd5b8bb,
    0xbbbbbb,
    0x9cbebb,
    0x71c2bb,
    0x00c5bb
]

private let protan_confusion_line_3: [UInt32] = [
    0xfe6ee0,
    0xeb75e0,
    0xd57be0,
    0xbb80e0,
    0x9c86e0,
    0x718be0,
    0x0090e0
]

private let protan_confusion_line_4: [UInt32] = [
    0xfedc88,
    0xebdf88,
    0xd5e189,
    0xbbe489,
    0x9ce789,
    0x71e989,
    0x00ec89
]

private let protan_confusion_line_5: [UInt32] = [
    0xfee3e6,
    0xebe6e7,
    0xd5e9e7,
    0xbbebe7,
    0x9ceee7,
    0x71f0e7,
    0x00f3e7
]

private let tritan_confusion_line_1: [UInt32] = [
    0x708300,
    0x797d71,
    0x82759c,
    0x896dbb,
    0x9064d5,
    0x975aeb,
    0x9d4efe
]

private let tritan_confusion_line_2: [UInt32] = [
    0xc9aefe,
    0xc5b2eb,
    0xc0b7d5,
    0xbbbbbb,
    0xb6bf9c,
    0xb1c371,
    0xabc700
]

private let tritan_confusion_line_3: [UInt32] = [
    0x937efe,
    0x8c85eb,
    0x858cd5,
    0x7d92bb,
    0x74979c,
    0x6b9d71,
    0x60a200
]

private let tritan_confusion_line_4: [UInt32] = [
    0xf1d0fe,
    0xedd4eb,
    0xead7d5,
    0xe6dbbb,
    0xe2de9c,
    0xdee271,
    0xdae500
]

private let tritan_confusion_line_5: [UInt32] = [
    0xebe3fe,
    0xe7e6eb,
    0xe4e9d5,
    0xe0ecbb,
    0xdcf09c,
    0xd8f371,
    0xd4f600
]
