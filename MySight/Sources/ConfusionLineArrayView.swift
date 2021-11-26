//
//  ConfusionLineArrayView.swift
//  MySightPOC
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
        Group {
            ConfusionLineArrayView(cvd: .deutan, severity: .constant(0.0))
            ConfusionLineArrayView(cvd: .protan, severity: .constant(0.0))
            ConfusionLineArrayView(cvd: .tritan, severity: .constant(0.0))
        }
        .padding(24)
        .previewLayout(.sizeThatFits)
    }
}
