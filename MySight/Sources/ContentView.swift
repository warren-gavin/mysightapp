//
//  ContentView.swift
//  MySightPOC
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
            ZStack {
                if image == nil {
                    CVDCameraSimulationView(cvd: $cvd, severity: $severity)
                }

                VStack {
                    ImageView(image: $image.animation(),
                              cvd: $cvd,
                              severity: $severity)
                        .transition(.move(edge: .bottom))

                    Spacer()

                    ControlPanelView(frame: proxy.frame(in: .local),
                                     cvd: $cvd,
                                     severity: $severity,
                                     addNewProfile: $addNewProfile,
                                     loadImage: $loadImage)
                        .padding(.horizontal, 20.0)
                        .padding(.vertical, 20.0)
                        .backgroundStyle()
                        .padding(.bottom, 24.0)
                        .padding(.horizontal, 24.0)
                        .opacity(showControls ? 1.0 : 0.0)
                        .onTapGesture {}
                }
            }
            .onTapGesture {
                showControls.toggle()
            }
        }
        .sheet(isPresented: $addNewProfile, onDismiss: nil) {
            CVDAnalysisView(CVDAnalysisViewModel(profileManager: profileManager))
                .padding()
        }
        .sheet(isPresented: $loadImage, onDismiss: nil) {
            ImagePicker(image: $image)
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: !showControls)
        .environmentObject(profileManager)
    }
}

struct Background: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        } else {
            content
                .background(Color.background)
        }
    }
}

extension View {
    func backgroundStyle() -> some View {
        modifier(Background())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ContentView()
                .preferredColorScheme($0)
        }
    }
}
