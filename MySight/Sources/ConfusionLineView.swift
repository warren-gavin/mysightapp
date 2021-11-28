//
//  ConfusionLineView.swift
//  MySight
//
//  Created by Warren Gavin on 12/11/2021.
//

import SwiftUI

struct ConfusionLineView: View {
    private static let squareLength: CGFloat = 40.0
    
    let confusionLine: ConfusionLine
    @Binding var severity: Float
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(confusionLine.colors, id: \.self) {
                $0.map(toCvdType: confusionLine.cvd,
                       severity: Double(severity))
            }
        }
        .frame(width: width, height: height, alignment: .top)
    }
}

private extension ConfusionLineView {
    var width: CGFloat {
        Self.squareLength * CGFloat(confusionLine.size)
    }
    
    var height: CGFloat {
        Self.squareLength
    }
}

struct ConfusionLineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ConfusionLine.allDeutans, id: \.self) { colors in
                VStack(spacing: 2) {
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.0))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.2))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.4))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.6))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.8))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(1.0))
                }
            }
            ForEach(ConfusionLine.allProtans, id: \.self) { colors in
                VStack(spacing: 2) {
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.0))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.2))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.4))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.6))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.8))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(1.0))
                }
            }
            ForEach(ConfusionLine.allTritans, id: \.self) { colors in
                VStack (spacing: 2) {
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.0))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.2))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.4))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.6))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(0.8))
                    ConfusionLineView(confusionLine: colors,
                                      severity: .constant(1.0))
                }
            }
        }
        .padding(24)
        .previewLayout(.sizeThatFits)
    }
}
