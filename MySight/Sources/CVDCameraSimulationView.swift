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
    @Binding var orientation: UIDeviceOrientation
    let enableFilter: Bool

    var body: some View {
        GeometryReader { proxy in
            cameraView(frame: proxy.frame(in: .local))
//                .gesture(
//                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
//                        .onEnded { _ in
//                            backCamera.toggle()
//                        }
//                )
        }
    }
}

extension CVDCameraSimulationView {
    func cameraView(frame: CGRect) -> some View {
#if targetEnvironment(simulator)
        SimulatorCameraView(cvd: cvd,
                            severity: enableFilter ? severity : 0,
                            orientation: $orientation)
#else
        CameraView(frame: frame,
                   simulating: $cvd,
                   severity: enableFilter ? $severity : .constant(0),
                   backCamera: $backCamera)
#endif
    }
}

struct CVDSimulationView_Previews: PreviewProvider {
    static var previews: some View {
        CVDCameraSimulationView(cvd: .constant(.deutan),
                                severity: .constant(1.0),
                                orientation: .constant(.portrait),
                                enableFilter: true)
            .edgesIgnoringSafeArea(.all)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
