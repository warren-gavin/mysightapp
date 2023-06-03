//
//  PreviewDevices.swift
//  MySight
//
//  Created by Warren Gavin on 30/11/2021.
//

import SwiftUI

extension PreviewDevice {
    static let eight = PreviewDevice(rawValue: "iPhone 8")
    static let eightPlus = PreviewDevice(rawValue: "iPhone 8 Plus")
    static let eleven = PreviewDevice(rawValue: "iPhone 11")
    static let elevenPro = PreviewDevice(rawValue: "iPhone 11 Pro")
    static let elevenProMax = PreviewDevice(rawValue: "iPhone 11 Pro Max")
    static let twelve = PreviewDevice(rawValue: "iPhone 12")
    static let twelvePro = PreviewDevice(rawValue: "iPhone 12 Pro")
    static let twelveProMax = PreviewDevice(rawValue: "iPhone 12 Pro Max")
    static let twelveMini = PreviewDevice(rawValue: "iPhone 12 mini")
    static let thirteen = PreviewDevice(rawValue: "iPhone 13")
    static let thirteenPro = PreviewDevice(rawValue: "iPhone 13 Pro")
    static let thirteenProMax = PreviewDevice(rawValue: "iPhone 13 Pro Max")
    static let thirteenMini = PreviewDevice(rawValue: "iPhone 13 mini")
    static let fourteen = PreviewDevice(rawValue: "iPhone 14")
    static let fourteenPlus = PreviewDevice(rawValue: "iPhone 14 Plus")
    static let fourteenPro = PreviewDevice(rawValue: "iPhone 14 Pro")
    static let fourteenProMax = PreviewDevice(rawValue: "iPhone 14 Pro Max")
    static let se = PreviewDevice(rawValue: "iPhone SE (2nd generation)")
    static let touch = PreviewDevice(rawValue: "iPod Touch (7th generation)")

    static var allPhoneDevices: [PreviewDevice] {
        [
            .eight,
            .eightPlus,
            .eleven,
            .elevenPro,
            .elevenProMax,
            .twelve,
            .twelvePro,
            .twelveProMax,
            .twelveMini,
            .thirteen,
            .thirteenPro,
            .thirteenProMax,
            .thirteenMini,
            .fourteen,
            .fourteenPro,
            .fourteenPlus,
            .fourteenProMax,
            .se,
            .touch
        ]
    }
}
