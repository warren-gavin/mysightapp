//
//  SimulatorCameraView+AppStoreScreenshots.swift
//  AppStoreScreenshots
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
        let orientation = (UIDevice.current.orientation == .portrait ? "portrait" : "landscape")

        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: "ipad-pro-3-12.9.\(orientation)")!
        }

        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 2.0 {
            return UIImage(named: "iphone-5.5.\(orientation)")!
        }

        return UIImage(named: "iphone-6.5.\(orientation)")!
    }
}

struct SimulatorCameraView_Previews: PreviewProvider {
    static var previews: some View {
        SimulatorCameraView(cvd: .deutan, severity: 1.0)
    }
}
