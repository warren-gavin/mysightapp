//
//  UIImage+CVD.swift
//  MySight
//
//  Created by Warren Gavin on 06/01/2022.
//

import UIKit

extension UIImage {
    func applyCVDFilter(cvd: CVD, severity: Float) -> UIImage? {
        let filter = CVDFilter(cvd: cvd, severity: severity)
        return filter.filteredImage(with: self)
    }
}
