//
//  CVDCameraSimulationView.swift
//  MySight
//
//  Created by Warren Gavin on 07/11/2021.
//

import SwiftUI

struct CVDCameraSimulationView: View {
    @State private var backCamera = true

    @Binding var cvd: CVD
    @Binding var severity: Float

    var body: some View {
        GeometryReader { proxy in
            cameraView(frame: proxy.frame(in: .local))
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onEnded { _ in
                            backCamera.toggle()
                        }
                )
        }
    }
}

extension CVDCameraSimulationView {
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
                   backCamera: $backCamera)
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
