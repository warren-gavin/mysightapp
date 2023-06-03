//
//  ConfusionLineArrayView.swift
//  MySight
//
//  Created by Warren Gavin on 12/11/2021.
//

import SwiftUI

struct ConfusionLineArrayView: View {
    let cvd: CVD
    @Binding var severity: Float
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(confusionLines, id: \.self) { line in
                ConfusionLineView(confusionLine: line, severity: $severity)
            }
        }
    }
}

private extension ConfusionLineArrayView {
    var confusionLines: [ConfusionLine] {
        switch cvd {
        case .deutan:
            return ConfusionLine.allDeutans

        case .protan:
            return ConfusionLine.allProtans

        case .tritan:
            return ConfusionLine.allTritans
        }
    }
}

struct ConfusionLineArrayView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            HStack(spacing: 24) {
                ConfusionLineArrayView(cvd: .deutan, severity: .constant(0.0))
                ConfusionLineArrayView(cvd: .protan, severity: .constant(0.0))
                ConfusionLineArrayView(cvd: .tritan, severity: .constant(0.0))
            }
            HStack(spacing: 24) {
                ConfusionLineArrayView(cvd: .deutan, severity: .constant(1.0))
                ConfusionLineArrayView(cvd: .protan, severity: .constant(1.0))
                ConfusionLineArrayView(cvd: .tritan, severity: .constant(1.0))
            }
        }
        .padding(24)
        .background(Color(hex: 0x343837, alpha: 1.0))
        .previewLayout(.sizeThatFits)
    }
}
