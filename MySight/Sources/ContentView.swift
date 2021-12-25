//
//  ContentView.swift
//  MySight
//
//  Created by Warren Gavin on 18/11/2021.
//

import SwiftUI

struct ContentView: View {
    private let profileManager: CVDProfileManager

    @State private var severity: Float
    @State private var cvd: CVD

    @State private var showControls = true
    @State private var addNewProfile = false

    @State private var image: UIImage?
    @State private var loadImage = false

    init() {
        profileManager = CVDProfileManager()

        cvd = profileManager.activeProfile.cvd
        severity = profileManager.activeProfile.severity
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                if image == nil {
                    CVDCameraSimulationView(cvd: $cvd, severity: $severity)
                        .ignoresSafeArea()
                }

                VStack {
                    ImageView(image: $image.animation(),
                              cvd: $cvd,
                              severity: $severity)
                        .transition(.move(edge: .bottom))

                    HStack(spacing: 0) {
                        Spacer(minLength: spacerMinLength(in: proxy.frame(in: .local)))

                        ControlPanelView(cvd: $cvd,
                                         severity: $severity,
                                         addNewProfile: $addNewProfile,
                                         loadImage: $loadImage,
                                         show: $showControls)
                            .padding(.vertical, showControls ? 20.0 : 8.0)
                            .background(.ultraThinMaterial,
                                        in: RoundedRectangle(cornerRadius: 24))                            .padding(.bottom, 8.0)
                            .padding(.horizontal, showControls ? 24.0 : 12.0)
                            .onTapGesture {}
                    }
                    .ignoresSafeArea()
                }
            }
            .onTapGesture {
                withAnimation {
                    showControls.toggle()
                }
            }
        }
        .sheet(isPresented: $addNewProfile, onDismiss: nil) {
            CVDAnalysisView(CVDAnalysisViewModel(profileManager: profileManager),
                            severity: $severity)
                .padding()
        }
        .sheet(isPresented: $loadImage, onDismiss: nil) {
            ImagePicker(image: $image)
        }
        .statusBar(hidden: !showControls)
        .environmentObject(profileManager)
    }
}

private extension ContentView {
    func spacerMinLength(in frame: CGRect) -> CGFloat {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return showControls ? 400 : 200

        default:
            return 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(PreviewDevice.allPhoneDevices, id: \.rawValue) {
            ContentView()
                .previewDevice($0)
                .previewDisplayName($0.rawValue)
        }
    }
}
