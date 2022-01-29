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

    init() {
        profileManager = CVDProfileManager()

        cvd = profileManager.activeProfile.cvd
        severity = profileManager.activeProfile.severity
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                if image == nil {
                    CVDCameraSimulationView(cvd: $cvd,
                                            severity: $severity,
                                            orientation: $orientation,
                                            enableFilter: enableFilter)
                        .accessibilityIdentifier("camera view")
                        .ignoresSafeArea()
                }

                VStack(alignment: .trailing) {
                    if let _ = image {
                        ImageView(image: $image.animation(),
                                  cvd: $cvd,
                                  severity: $severity)
                            .transition(.move(edge: .bottom))
                    }
                    else if showControls {
                        HStack {
                            Button {
                                addNewProfile = true
                            } label: {
                                Image(systemName: "plus")
                            }
                            .accessibilityIdentifier("add new profile")
                            .imageStyle()
                            .fixedSize(horizontal: true, vertical: true)

                            Spacer()

                            Button {
                                loadImage = true
                            } label: {
                                Image(systemName: "photo.on.rectangle.angled")
                            }
                            .accessibilityIdentifier("select image")
                            .imageStyle()
                            .fixedSize(horizontal: true, vertical: true)
                        }
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }

                    HStack {
                        ControlPanelView(cvd: $cvd,
                                         severity: $severity,
                                         show: $showControls,
                                         orientation: $orientation,
                                         enableFilter: $enableFilter,
                                         showHelp: $showHelp)
                            .padding(.top, 8.0)
                            .padding(.bottom, showControls ? 20.0 : 8.0)
                            .background(.ultraThinMaterial,
                                        in: RoundedRectangle(cornerRadius: 24))
                            .padding(.bottom, 8.0)
                            .onTapGesture {}
                    }
                    .padding(.horizontal)
                    .ignoresSafeArea()
                }
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
            Color.red
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
        let manager = CVDProfileManager()
        manager.save(profile: CVDProfile(name: "Test", cvd: .deutan, severity: 0.7))
        manager.save(profile: CVDProfile(name: "Test with long name", cvd: .protan, severity: 0.7))
        manager.activeProfile = CVDProfile.standardProfiles.first!

        return ContentView()
            .environmentObject(manager)
            .previewDevice(PreviewDevice.eight)
            .previewDisplayName(PreviewDevice.eight.rawValue)
//            .previewInterfaceOrientation(.landscapeLeft)
            .environment(\.sizeCategory, .extraExtraExtraLarge)

    }
}
