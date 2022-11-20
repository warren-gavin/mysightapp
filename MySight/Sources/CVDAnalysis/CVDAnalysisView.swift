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

    @State private var userEstimatedSeverity: Float = .userEstimateReset
    @State private var confusionLine: ConfusionLine?
    @State private var newProfileName = ""

    @AccessibilityFocusState private var a11yFocusOnSlider

    @ObservedObject private var viewModel: CVDAnalysisViewModel

    init(_ viewModel: CVDAnalysisViewModel, severity: Binding<Float>) {
        let confusionLine = viewModel.loadNext(confusionLine: nil,
                                               severity: 0.0)!

        self.viewModel = viewModel
        self._confusionLine = State<ConfusionLine?>(wrappedValue: confusionLine)
        self._activeSeverity = severity
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Add a new CVD profile")
                .padding(.top, 44)
                .padding(.bottom, 16)
                .condensible(style: .title, weight: .black)

            Spacer()

            if viewModel.showIntro {
                CVDAnalysisIntroView(userEstimatedSeverity: $userEstimatedSeverity)
            }
            else if confusionLine != nil {
                CVDAnalysisStepView(confusionLine: confusionLine!,
                                    progress: viewModel.completionProgress,
                                    userEstimatedSeverity: $userEstimatedSeverity)
            }
            else {
                CVDAnalysisResultview(cvd: viewModel.probableCvdAndSeverity.0,
                                      severity: viewModel.probableCvdAndSeverity.1,
                                      newProfileName: $newProfileName)
            }

            Spacer()

            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .condensible()
                }
                .accessibilityIdentifier("cancel")

                Spacer()

                if viewModel.showIntro {
                    Button {
                        userEstimatedSeverity = .userEstimateReset
                        viewModel.introWasRead()
                    } label: {
                        Text("Next")
                            .condensible()
                    }
                    .accessibilityIdentifier("start analysis")
                }
                else if confusionLine != nil {
                    Button {
                        self.confusionLine = viewModel.loadNext(confusionLine: confusionLine,
                                                                severity: userEstimatedSeverity)
                        userEstimatedSeverity = .userEstimateReset
                        a11yFocusOnSlider = true
                    } label: {
                        Text("Next")
                            .condensible()
                    }
                    .accessibilityIdentifier("next cvd analysis")
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
                    .accessibilityIdentifier("save cvd profile")
                    .disabled(newProfileName.isEmpty)
                }
            }
            .padding(.vertical, 24)
        }
    }
}

private extension Float {
    static var userEstimateReset: Float {
        Bundle.main.bundleIdentifier == "com.apokrupto.AppStoreScreenshots" ? 1.0 : 0.0
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
