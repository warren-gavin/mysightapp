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

    @State private var orientation = UIDevice.current.orientation

    @State private var enableFilter = true
    @State private var showHelp = false

    init(profileManager: CVDProfileManager = CVDProfileManager()) {
        self.profileManager = profileManager
        cvd = profileManager.activeProfile.cvd
        severity = profileManager.activeProfile.severity
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                if let image {
                    ImageView(image: image,
                              cvd: $cvd,
                              severity: enableFilter ? $severity : .constant(0)) {
                        withAnimation {
                            self.image = nil
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
                else {
                    CVDCameraSimulationView(cvd: $cvd,
                                            severity: enableFilter ? $severity : .constant(0),
                                            orientation: $orientation)
                        .accessibilityIdentifier("camera view")
                        .ignoresSafeArea()
                }

                VStack(alignment: .trailing) {
                    if showControls, image == nil {
                        HStack {
                            Button {
                                addNewProfile = true
                            } label: {
                                Image(systemName: "plus")
                            }
                            .imageStyle()
                            .accessibilityLabel("Add a new profile")
                            .accessibilityHint("Create a short cut to the exact colourblindness of someone you know.")
                            .accessibilityIdentifier("add new profile")

                            Spacer()

                            Button {
                                loadImage = true
                            } label: {
                                Image(systemName: "photo.on.rectangle.angled")
                            }
                            .imageStyle()
                            .accessibilityLabel("Open photo album")
                            .accessibilityHint("See your photos in colourblind mode!")
                            .accessibilityIdentifier("select image")
                        }
//                        .padding()
                        .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }

                    ControlPanelView(cvd: $cvd,
                                     severity: $severity,
                                     show: $showControls,
                                     orientation: $orientation,
                                     enableFilter: $enableFilter,
                                     showHelp: $showHelp)
                        .padding(.bottom, 14.0)
                        .onTapGesture {}
                }
                .padding(.horizontal)
                .ignoresSafeArea(edges: [.bottom])
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
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
        .sheet(isPresented: $showHelp, onDismiss: nil) {
            TechnicalTermsHelpView()
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .statusBar(hidden: !showControls)
        .environmentObject(profileManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CVDProfileManager(
            userDefaults: UserDefaults(
                suiteName: "com.apokrupto.preview.content-view"
            )!
        )
//        manager.save(profile: CVDProfile(name: "Test", cvd: .deutan, severity: 0.7))
//        manager.save(profile: CVDProfile(name: "Test with long name", cvd: .protan, severity: 0.7))
        manager.activeProfile = CVDProfile.standardProfiles.first!

        let previewDevices = [
            PreviewDevice.eight,
            PreviewDevice.thirteenPro,
            PreviewDevice.fourteenProMax
        ]

        let preview = Group {
            ForEach(previewDevices, id: \.rawValue) { previewDevice in
                ContentView(profileManager: manager)
                    .previewDevice(previewDevice)
                    .previewDisplayName(previewDevice.rawValue)
                    .previewInterfaceOrientation(.portrait)
            }
        }

        return preview
    }
}
