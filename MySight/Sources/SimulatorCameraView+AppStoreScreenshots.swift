//
//  SimulatorCameraView+AppStoreScreenshots.swift
//  AppStoreScreenshots
//
//  Created by Warren Gavin on 15/01/2022.
//

import SwiftUI

#if targetEnvironment(simulator)
struct SimulatorCameraView: View {
    let cvd: CVD
    let severity: Float
    @Binding var orientation: UIDeviceOrientation

    var body: some View {
        Image(uiImage: image.applyCVDFilter(cvd: cvd, severity: severity)!)
            .resizable()
    }
}

extension SimulatorCameraView {
    var image: UIImage {
        let orientationString = (orientation == .portrait || orientation == .portraitUpsideDown ? "portrait" : "landscape")

        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: "ipad-pro-3-12.9.\(orientationString)")!
        }

        var aspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width

        if orientation == .portraitUpsideDown {
            aspectRatio = 1 / aspectRatio
        }

        if aspectRatio < 2.0 {
            return UIImage(named: "iphone-5.5.\(orientationString)")!
        }

        return UIImage(named: "iphone-6.5.\(orientationString)")!
    }
}

struct SimulatorCameraView_Previews: PreviewProvider {
    static var previews: some View {
        SimulatorCameraView(cvd: .deutan, severity: 1.0, orientation: .constant(.portrait))
    }
}
#endif
