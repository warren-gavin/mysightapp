//
//  CVDAnalysisIntroView.swift
//  MySight
//
//  Created by Warren Gavin on 19/11/2022.
//

import SwiftUI

struct CVDAnalysisIntroView: View {
    @Binding var userEstimatedSeverity: Float

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("cvd.analysis.intro")
                    .condensible()

                HStack {
                    Spacer()
                    ConfusionLineView(confusionLine: .tritan_2, severity: .constant(0.0))
                        .padding(.vertical, 24)
                    Spacer()
                }

                Text("cvd.analysis.explanation")
                    .condensible()

                HStack {
                    Spacer()
                    ConfusionLineView(confusionLine: .tritan_2,
                                      severity: $userEstimatedSeverity)
                    Spacer()
                }
                .padding(.vertical, 24)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true),
                           value: userEstimatedSeverity)
                .onAppear {
                    userEstimatedSeverity = 1.0
                }
            }
        }
    }
}

struct CVDAnalysisIntroView_Previews: PreviewProvider {
    static var previews: some View {
        CVDAnalysisIntroView(userEstimatedSeverity: .constant(0.6))
    }
}
