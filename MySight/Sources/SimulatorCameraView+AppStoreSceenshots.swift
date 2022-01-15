//
//  SimulatorCameraView+AppStoreSceenshots.swift
//  AppStoreSceenshots
//
//  Created by Warren Gavin on 15/01/2022.
//

import SwiftUI

struct SimulatorCameraView: View {
    let cvd: CVD
    let severity: Float

    var body: some View {
        Image(uiImage: image.applyCVDFilter(cvd: cvd, severity: severity)!)
            .resizable()
    }
}

extension SimulatorCameraView {
    var image: UIImage {
        switch (UIDevice.current.userInterfaceIdiom, UIDevice.current.orientation) {
        case (.pad, .portrait):
            return UIImage(named: "ipad-pro-3-12.9.portrait")!

        case (.pad, .landscapeRight), (.pad, .landscapeLeft):
            return UIImage(named: "ipad-pro-3-12.9.landscape")!

        case (.phone, .portrait):
            return UIImage(named: "iphone-6.5.portrait")!

        case (.phone, .landscapeRight), (.phone, .landscapeLeft):
            return UIImage(named: "iphone-6.5.landscape")!

        default:
            fatalError("Wrong device or orientation")
        }
    }
}

struct SimulatorCameraView_Previews: PreviewProvider {
    static var previews: some View {
        SimulatorCameraView(cvd: .deutan, severity: 1.0)
    }
}
