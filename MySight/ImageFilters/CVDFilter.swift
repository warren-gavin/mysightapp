//
//  CVDFilter.swift
//  MySight
//
//  Created by Warren Gavin on 08/11/2021.
//

import BBMetalImage
import Metal
import simd
import SwiftUI

/// Transforms the colors of an image by applying a matrix to them to simulate Color Vision Deficiency
final class CVDFilter: BBMetalBaseFilter {
    /// The type of color vision deficiency
    var cvd: CVD
    
    /// The degree of CVD
    var severity: Float

    init(cvd: CVD, severity: Float = 1) {
        self.cvd = cvd
        self.severity = severity
        
        super.init(kernelFunctionName: "cvdKernel", useMainBundleKernel: true)
    }
    
    override func updateParameters(for encoder: MTLComputeCommandEncoder, texture: BBMetalTexture) {
        var rawCvd = cvd.rawValue
        
        encoder.setBytes(&rawCvd, length: MemoryLayout<CVD.RawValue>.size, index: 0)
        encoder.setBytes(&severity, length: MemoryLayout<Float>.size, index: 1)
    }
}
