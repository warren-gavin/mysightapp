//
//  CVDAnalysisView.swift
//  MySight
//
//  Created by Warren Gavin on 13/11/2021.
//

import SwiftUI

struct CVDAnalysisView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding private var activeSeverity: Float

    @State private var userEstimatedSeverity: Float = 0.0
    @State private var confusionLine: ConfusionLine
    @State private var newProfileName = ""

    private let viewModel: CVDAnalysisViewModel

    init(_ viewModel: CVDAnalysisViewModel, severity: Binding<Float>) {
        let confusionLine = viewModel.loadNext(confusionLine: nil,
                                               severity: 0.0)!

        self.viewModel = viewModel
        self._confusionLine = State<ConfusionLine>(wrappedValue: confusionLine)
        self._activeSeverity = severity
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add a new CVD setting")
                .padding(.top, 44)
                .padding(.bottom, 16)
                .font(Font.title.weight(.black))

            Text("Move the slider until you see a solid rectangle")
                .font(.headline)
                .padding(.bottom, 8)
                .opacity(textOpacity)

            Text("If you already see a rectangle, hit Next")
                .font(.subheadline)
                .opacity(textOpacity)
                .padding(.bottom, 24)

            Spacer()

            HStack {
                Spacer()
                if !viewModel.analysisComplete {
                    VStack {
                        ConfusionLineView(confusionLine: confusionLine,
                                          severity: $userEstimatedSeverity)
                        Slider(value: $userEstimatedSeverity, in: 0.0 ... 1.0)
                            .padding(.top)
                            .frame(maxWidth: 400)
                    }
                }
                else {
                    analysisResultView
                }
                Spacer()
            }

            Spacer()

            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }

                Spacer()

                if !viewModel.analysisComplete {
                    Button("Next") {
                        if let confusionLine = viewModel.loadNext(confusionLine: confusionLine,
                                                                  severity: userEstimatedSeverity) {
                            self.confusionLine = confusionLine
                            userEstimatedSeverity = 0.0
                        }
                    }
                }
                else {
                    Button("Save") {
                        let (cvd, severity) = viewModel.probableCvdAndSeverity
                        viewModel.save(profile: CVDProfile(name: newProfileName,
                                                           cvd: cvd,
                                                           severity: severity)) {
                            activeSeverity = severity
                        }

                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(newProfileName.isEmpty)
                }
            }
            .padding(.vertical, 24)
        }
    }
}

private extension CVDAnalysisView {
    var textOpacity: CGFloat {
        viewModel.analysisComplete ? 0.0 : 1.0
    }

    var analysisResultView: some View {
        let (cvd, severity) = viewModel.probableCvdAndSeverity
        let diagnosis: LocalizedStringKey

        switch severity {
        case 1.0...:
            diagnosis = cvd.dichromatName

        case 0.09 ... 1.0:
            diagnosis = cvd.anomalousTrichromatName

        default:
            diagnosis = "Normal Colour Vision"
        }

        return VStack {
            Text(diagnosis)
                .font(.largeTitle)
            Text(severityEstimate(severity: severity))
            TextField("Save as...", text: $newProfileName)
                .padding(.top, 16)
        }
    }

    func severityEstimate(severity: Float) -> String {
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

struct CVDAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            CVDAnalysisView(CVDAnalysisViewModel(profileManager: CVDProfileManager()),
                            severity: .constant(1.0))
                .padding(24)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme($0)
        }
    }
}
