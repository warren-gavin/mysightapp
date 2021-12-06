//
//  Collection+SafeSubscript.swift
//  MySight
//
//  Created by Warren Gavin on 03/12/2021.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
