//
//  TechnicalTermsHelpView.swift
//  MySight
//
//  Created by Warren Gavin on 01/02/2022.
//

import SwiftUI

struct TechnicalTermsHelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("What's all this?")
                    .condensible(style: .title, weight: .black)
                    .padding(.vertical, 12)

                Text("help.para.1")
                    .accessibilityLabel("help.para.1.a11y")
                    .padding(.bottom, 12)

                ConeGraphView(label: "Normal Colour Vision/Trichromat")
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(
                        "Graph showing normal colour vision, where all three cones are at their maximum heights"
                    )

                Text("help.para.2")
                    .accessibilityLabel("help.para.2.a11y")

                ConeGraphView(label: "Anomalous trichromacy", redScale: 0.4)
                    .accessibilityLabel(
                        "Graph showing protanomaly, where the red cone works at only 40% of the normal value"
                    )

                ConeGraphView(label: "Dichromat", greenScale: 0.0)
                    .accessibilityLabel(
                        "Graph showing deuteranopia, where the green cone doesn't work at all"
                    )

                Text("What about the Deutans? I want to know about the Deutans!")
                    .condensible(style: .subheadline, weight: .black)
                    .padding(.vertical, 12)

                Text("help.para.3")
                    .accessibilityLabel("help.para.3.a11y")

                HStack {
                    Spacer()
                    InteractiveConesView()
                        .accessibilityLabel(
                            "Animation showing the different types of colourblindness"
                        )
                        .frame(height: 200)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                    Spacer()
                }
            }
            .padding(.horizontal, 12)
        }
    }
}

struct TechnicalTermsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        TechnicalTermsHelpView()
    }
}
