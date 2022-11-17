//
//  TechnicalTermsHelpView.swift
//  MySight
//
//  Created by Warren Gavin on 01/02/2022.
//

import SwiftUI

struct TechnicalTermsHelpView: View {
    private let conesViewHeight: CGFloat = 200
    private let conesViewWidth = min(UIScreen.main.bounds.width * 0.8, 500)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                intro

                severityTerms

                Text("What about the Deutans? I want to know about the Deutans!")
                    .condensible(style: .subheadline, weight: .black)
                    .padding(.vertical, 12)

                Text("help.para.3")

                HStack {
                    Spacer()
                    InteractiveConesView()
                        .frame(width: conesViewWidth, height: conesViewHeight)
                        .padding(.bottom, 12)
                    Spacer()
                }
            }
            .padding(.horizontal, 12)
        }
    }
}

private extension TechnicalTermsHelpView {
    var intro: some View {
        Group {
            Text("What's all this?")
                .condensible(style: .title, weight: .black)
                .padding(.vertical, 12)

            Text("help.para.1")
                .padding(.bottom, 12)

            HStack {
                Spacer()
                StaticConesView()
                    .frame(width: conesViewWidth, height: conesViewHeight)
                Spacer()
            }

            Text("Normal Colour Vision/Trichromat")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom, 12)
        }
    }

    var severityTerms: some View {
        Group {
            Text("help.para.2")

            HStack {
                Spacer()
                StaticConesView(redScale: 0.4)
                    .frame(width: conesViewWidth, height: conesViewHeight)
                Spacer()
            }

            Text("Anomalous trichromacy")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom, 12)

            HStack {
                Spacer()
                StaticConesView(greenScale: 0.0)
                    .frame(width: conesViewWidth, height: conesViewHeight)
                Spacer()
            }

            Text("Dichromat")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom, 12)
        }
    }
}

struct TechnicalTermsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        TechnicalTermsHelpView()
    }
}
