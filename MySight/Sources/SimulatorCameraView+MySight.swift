//
//  SimulatorCameraView+MySight.swift
//  MySight
//
//  Created by Warren Gavin on 15/01/2022.
//

import SwiftUI

struct SimulatorCameraView: View {
    let cvd: CVD
    let severity: Float

    var body: some View {
        switch cvd {
        case .deutan:
            return Color.green.opacity(Double(severity))

        case .protan:
            return Color.red.opacity(Double(severity))

        case .tritan:
            return Color.blue.opacity(Double(severity))
        }
    }
}

struct SimulatorCameraView_Previews: PreviewProvider {
    static var previews: some View {
        SimulatorCameraView(cvd: .deutan, severity: 1.0)
    }
}

