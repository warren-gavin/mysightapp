//
//  CVDAnalysisResultview.swift
//  MySight
//
//  Created by Warren Gavin on 20/11/2022.
//

import SwiftUI

struct CVDAnalysisResultview: View {
    let cvd: CVD
    let severity: Float
    @Binding var newProfileName: String

    @FocusState private var textFieldFocus

    var body: some View {
        VStack {
            Text(diagnosis)
                .condensible(style: .largeTitle)

            Text(severityEstimate)
                .condensible()

            TextField("Save as...", text: $newProfileName)
                .accessibilityIdentifier("save as field")
                .focused($textFieldFocus)
                .padding(.top, 16)
        }
        .task {
            textFieldFocus = true
        }
    }
}

private extension CVDAnalysisResultview {
    var diagnosis: LocalizedStringKey {
        switch severity {
        case 1.0...:
            return cvd.dichromatName

        case 0.09 ... 1.0:
            return cvd.anomalousTrichromatName

        default:
            return "Normal Colour Vision"
        }
    }

    var severityEstimate: String {
        switch severity {
        case 1.0...:
            return String(format: NSLocalizedString("100%% dichromacy", comment: ""))

        case 0.09 ... 1.0:
            return String(format: NSLocalizedString("%lld%% anomalous trichromacy", comment: ""),
                          Int(severity * 100))

        default:
            return " "
        }
    }
}

struct CVDAnalysisResultview_Previews: PreviewProvider {
    static var previews: some View {
        CVDAnalysisResultview(cvd: .protan,
                              severity: 0.75,
                              newProfileName: .constant(""))
    }
}
