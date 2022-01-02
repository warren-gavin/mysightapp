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
    @FocusState private var textFieldFocus: Bool

    @ObservedObject private var viewModel: CVDAnalysisViewModel

    init(_ viewModel: CVDAnalysisViewModel, severity: Binding<Float>) {
        let confusionLine = viewModel.loadNext(confusionLine: nil,
                                               severity: 0.0)!

        self.viewModel = viewModel
        self._confusionLine = State<ConfusionLine>(wrappedValue: confusionLine)
        self._activeSeverity = severity
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add a new CVD profile")
                .padding(.top, 44)
                .padding(.bottom, 16)
                .condensible(style: .title, weight: .black)

            if !viewModel.showIntro {
                instructionsView
            }

            Spacer()

            HStack {
                Spacer()
                if viewModel.showIntro {
                    introView
                }
                else if !viewModel.analysisComplete {
                    analysisView
                }
                else {
                    analysisResultView
                }
                Spacer()
            }

            Spacer()

            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .condensible()
                }

                Spacer()

                if viewModel.showIntro {
                    Button {
                        userEstimatedSeverity = 0.0
                        viewModel.introWasRead()
                    } label: {
                        Text("Next")
                            .condensible()
                    }
                }
                else if !viewModel.analysisComplete {
                    Button {
                        if let confusionLine = viewModel.loadNext(confusionLine: confusionLine,
                                                                  severity: userEstimatedSeverity) {
                            self.confusionLine = confusionLine
                            userEstimatedSeverity = 0.0
                        }
                    } label: {
                        Text("Next")
                            .condensible()
                    }
                }
                else {
                    Button {
                        let (cvd, severity) = viewModel.probableCvdAndSeverity
                        viewModel.save(profile: CVDProfile(name: newProfileName,
                                                           cvd: cvd,
                                                           severity: severity)) {
                            activeSeverity = severity
                        }

                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                            .condensible()
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

    var introView: some View {
        ScrollView {
            VStack {
                Text("cvd.analysis.intro")
                    .condensible()

                ConfusionLineView(confusionLine: .tritan_2, severity: .constant(0.0))
                    .padding(.vertical, 24)

                Text("cvd.analysis.explanation")
                    .condensible()

                VStack {
                    ConfusionLineView(confusionLine: .tritan_2,
                                      severity: $userEstimatedSeverity)
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

    var instructionsView: some View {
        Group {
            Text("Move the slider until you see a solid rectangle")
                .condensible(style: .headline)
                .padding(.bottom, 8)
                .opacity(textOpacity)

            Text("If you already see a rectangle, hit Next")
                .condensible(style: .subheadline)
                .opacity(textOpacity)
                .padding(.bottom, 24)
        }
    }

    var analysisView: some View {
        VStack {
            ConfusionLineView(confusionLine: confusionLine,
                              severity: $userEstimatedSeverity)
            Slider(value: $userEstimatedSeverity, in: 0.0 ... 1.0)
                .padding(.top)
                .frame(maxWidth: 400)
        }
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
                .condensible(style: .largeTitle)

            Text(severityEstimate(severity: severity))
                .condensible()

            TextField("Save as...", text: $newProfileName)
                .focused($textFieldFocus)
                .padding(.top, 16)
        }
        .onAppear {
            textFieldFocus = true
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
