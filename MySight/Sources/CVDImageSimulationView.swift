//
//  CVDImageSimulationView.swift
//  MySightPOC
//
//  Created by Warren Gavin on 20/11/2021.
//

import SwiftUI

struct CVDImageSimulationView: View {
    let image: UIImage

    @Binding var cvd: CVD
    @Binding var severity: Float

    var body: some View {
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
        filteredImage?
            .resizable()
            .aspectRatio(contentMode: .fit)
#endif
    }
}

private extension CVDImageSimulationView {
    var filteredImage: Image? {
        let filter = CVDFilter(cvd: cvd, severity: severity)

        guard let filteredImage = filter.filteredImage(with: image) else {
            return nil
        }

        return Image(uiImage: filteredImage)
    }
}

struct CVDImageSimulationView_Previews: PreviewProvider {
    static var previews: some View {
        CVDImageSimulationView(image: UIImage(systemName: "plus")!,
                               cvd: .constant(.deutan),
                               severity: .constant(1.0))
    }
}
