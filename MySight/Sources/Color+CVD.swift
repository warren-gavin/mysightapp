//
//  Color+CVD.swift
//  MySightPOC
//
//  Created by Warren Gavin on 14/11/2021.
//

import SwiftUI
import simd

extension Color {
    func map(toCvdType cvd: CVD, severity: Double) -> Color {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            fatalError("Can't get RGB values")
        }
        
        let color = SIMD3<Double>(Double(r), Double(g), Double(b))
        let rgbCvd: SIMD3<Double>
        
        switch (cvd) {
        case .deutan, .protan:
            rgbCvd = vienot1999ColorTransform(cvd: cvd, severity: severity, color: color)
            
        case .tritan:
            rgbCvd = brettel1997ColorTransform(severity: severity, color: color)
        }
        
        return Color(red: rgbCvd.x, green: rgbCvd.y, blue: rgbCvd.z).opacity(a)
    }
}

// Brettel 1997 simulation matrices
// --------------------------------
private let rgbToLms = double3x3(SIMD3<Double>(0.17886, 0.43997, 0.03597),
                                 SIMD3<Double>(0.03380, 0.27515, 0.03621),
                                 SIMD3<Double>(0.00031, 0.00192, 0.01528))

private let lmsToRgb = double3x3(SIMD3<Double>(8.00533, -12.88195, 11.68065),
                                 SIMD3<Double>(-0.97821, 5.26945, -10.18300),
                                 SIMD3<Double>(-0.04017, -0.39885, 66.48079))

private let tritanIndex = Int(CVD.tritan.rawValue)
private let tritanProjectionPlane1 = SIMD3<Double>(-0.00213, 0.05477, 0.00000)
private let tritanProjectionPlane2 = SIMD3<Double>(-0.06195, 0.16826, 0.00000)
private let tritanSeparationPlaneNormal = SIMD3<Double>(0.34516, -0.65480, 0.00000)

// Viénot 1999 simulation matrices
// -------------------------------
private let vienotDeutanRgbTransform = double3x3(SIMD3<Double>(0.29031, 0.70969, -0.00000),
                                                 SIMD3<Double>(0.29031, 0.70969, -0.00000),
                                                 SIMD3<Double>(-0.02197, 0.02197, 1.00000))

private let vienotProtanRgbTransform = double3x3(SIMD3<Double>(0.10889, 0.89111, -0.00000),
                                                 SIMD3<Double>(0.10889, 0.89111, 0.00000),
                                                 SIMD3<Double>(0.00447, -0.00447, 1.00000))

private extension Color {
    func brettel1997ColorTransform(severity: Double, color: SIMD3<Double>) -> SIMD3<Double> {
        let rgb = color.srgbToRgb
        var lms = rgb * rgbToLms
        
        let dotProduct = simd_dot(lms, tritanSeparationPlaneNormal)
        let projectionPlane = (dotProduct >= 0 ? tritanProjectionPlane1 : tritanProjectionPlane2)
        let projectedElement = simd_dot(projectionPlane, lms)
        
        let tritanIndex = Int(CVD.tritan.rawValue)
        lms[tritanIndex] = (severity * projectedElement) + ((1.0 - severity) * lms[tritanIndex])
        
        let rgbCvd =  lms * lmsToRgb
        
        return rgbCvd.rgbToSrgb
    }
    
    func vienot1999ColorTransform(cvd: CVD,
                                  severity: Double,
                                  color: SIMD3<Double>) -> SIMD3<Double> {
        let rgb = color.srgbToRgb
        let rgb_transform = (cvd == .deutan ? vienotDeutanRgbTransform : vienotProtanRgbTransform)
        
        var rgbCvd = rgb * rgb_transform
        
        if (severity < 0.999) {
            rgbCvd = (severity * rgbCvd) + ((1.0 - severity) * rgb)
        }
        
        return rgbCvd.rgbToSrgb
    }
}

private extension SIMD3 where Scalar == Double {
    var srgbToRgb: Self {
        Self(x.srgbToRgb, y.srgbToRgb, z.srgbToRgb)
    }
    
    var rgbToSrgb: Self {
        Self(x.rgbToSrgb, y.rgbToSrgb, z.rgbToSrgb)
    }
}

private extension Double {
    var srgbToRgb: Double {
        if self <= 0.04045 {
            return 0.0773993808 * self
        }
        
        return pow((self + 0.055) * 0.9478672986, 2.4)
    }
    
    var rgbToSrgb: Double {
        if self <= 0.0 {
            return 0.0
        }
        
        if self >= 1.0 {
            return 1.0
        }
        
        if self <= 0.0031308 {
            return 12.92 * self
        }
        
        return (pow(self, 0.4166666667) * 1.055) - 0.055
    }
}

