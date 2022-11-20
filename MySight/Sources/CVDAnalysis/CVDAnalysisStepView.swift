//
//  CVDAnalysisStepView.swift
//  MySight
//
//  Created by Warren Gavin on 19/11/2022.
//

import SwiftUI

struct CVDAnalysisStepView: View {
    let confusionLine: ConfusionLine
    let progress: Double
    @Binding var userEstimatedSeverity: Float
    @AccessibilityFocusState var a11yFocusOnSlider

    var body: some View {
        VStack(alignment: .leading) {
            Text("cvd.analysis.instruction.1")
                .condensible(style: .headline)
                .padding(.bottom, 0.2)

            Text("cvd.analysis.instruction.2")
                .condensible(style: .subheadline)

            Spacer()

            HStack {
                Spacer()
                ConfusionLineView(confusionLine: confusionLine,
                                  severity: $userEstimatedSeverity)
                Spacer()
            }

            Slider(value: $userEstimatedSeverity, in: 0.0 ... 1.0)
                .accessibilityIdentifier("severity analysis")
                .accessibilityFocused($a11yFocusOnSlider)
                .padding(.top)
                .frame(maxWidth: 400)

            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .padding(.top, 80)
                .frame(maxWidth: 400)
                .animation(.easeInOut, value: userEstimatedSeverity)
            Text("\(Int(100*progress))% complete")
                .opacity(0.5)

            Spacer()
        }
    }
}

struct CVDAnalysisStepView_Previews: PreviewProvider {
    static var previews: some View {
        CVDAnalysisStepView(confusionLine: .tritan_1,
                            progress: 0.7,
                            userEstimatedSeverity: .constant(0.25))
        .padding()
    }
}
