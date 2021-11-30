//
//  PreviewDevices.swift
//  MySight
//
//  Created by Warren Gavin on 30/11/2021.
//

import SwiftUI

extension PreviewDevice {
    enum PhoneDevices: String, CaseIterable {
        case eight = "iPhone 8"
//        case eightPlus = "iPhone 8 Plus"
//        case eleven = "iPhone 11"
        case elevenPro = "iPhone 11 Pro"
//        case elevenProMax = "iPhone 11 Pro Max"
//        case twelve = "iPhone 12"
//        case twelvePro = "iPhone 12 Pro"
        case twelveProMax = "iPhone 12 Pro Max"
//        case twelveMini = "iPhone 12 mini"
//        case thirteen = "iPhone 13"
//        case thirteenPro = "iPhone 13 Pro"
//        case thirteenProMax = "iPhone 13 Pro Max"
        case thirteenMini = "iPhone 13 mini"
//        case se = "iPhone SE (2nd generation)"
//        case touch = "iPod Touch (7th generation)"
    }

    static var allPhoneDevices: [PreviewDevice] {
        PhoneDevices.allCases.map {
            PreviewDevice(rawValue: $0.rawValue)
        }
    }
}
