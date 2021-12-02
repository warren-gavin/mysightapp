//
//  CVDCameraSimulationView.swift
//  MySight
//
//  Created by Warren Gavin on 07/11/2021.
//

import SwiftUI

struct CVDCameraSimulationView: View {
    @Binding var cvd: CVD
    @Binding var severity: Float

    @State private var backCamera = true
    @State private var enableCamera = true

    var body: some View {
        GeometryReader { proxy in
            FlippingView(flip: $backCamera) {
                cameraView(frame: proxy.frame(in: .local))
            } onFlipping: {
                if enableCamera {
                    enableCamera = false
                }
            } onFlipEnded: {
                enableCamera = true
            }
        }
    }
}

private extension CVDCameraSimulationView {
    func cameraView(frame: CGRect) -> some View {
#if targetEnvironment(simulator)
        switch cvd {
        case .deutan:
            return Color.green.opacity(Double(severity))
            
        case .protan:
            return Color.red.opacity(Double(severity))
            
        case .tritan:
            return Color.blue.opacity(Double(severity))
        }
#else
        CameraView(frame: frame,
                   simulating: $cvd,
                   severity: $severity,
                   backCamera: $backCamera,
                   enableCamera: $enableCamera)
#endif
    }
}

struct CVDSimulationView_Previews: PreviewProvider {
    static var previews: some View {
        CVDCameraSimulationView(cvd: .constant(.deutan),
                                severity: .constant(1.0))
            .edgesIgnoringSafeArea(.all)
    }
}
