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

                    if showControls {
                        HStack(spacing: 0) {
                            Spacer(minLength: spacerMinLength(in: proxy.frame(in: .local)))

                            ControlPanelView(cvd: $cvd,
                                             severity: $severity,
                                             addNewProfile: $addNewProfile,
                                             loadImage: $loadImage)
                            .padding(.vertical, 20.0)
                            .backgroundStyle()
                            .padding(.bottom, 8.0)
                            .padding(.horizontal, 24.0)
                            .onTapGesture {}
                        }
                        .ignoresSafeArea()
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    showControls.toggle()
                }
            }
        }
        .sheet(isPresented: $addNewProfile, onDismiss: nil) {
            CVDAnalysisView(CVDAnalysisViewModel(profileManager: profileManager))
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
            return 400

        default:
            return 0
        }
    }
}

struct Background: ViewModifier {
    struct Blur: UIViewRepresentable {
        var style: UIBlurEffect.Style = .systemUltraThinMaterial

        func makeUIView(context: Context) -> UIVisualEffectView {
            return UIVisualEffectView(effect: UIBlurEffect(style: style))
        }

        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            uiView.effect = UIBlurEffect(style: style)
        }
    }

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.background(.ultraThinMaterial,
                               in: RoundedRectangle(cornerRadius: 24))
        }
        else {
            content
                .background(Blur())
                .cornerRadius(24)
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
        Group {
            if #available(iOS 15.0, *) {
                ContentView()
                    .previewDevice(PreviewDevice(rawValue: PreviewDevice.PhoneDevices.twelveProMax.rawValue))
                    .previewInterfaceOrientation(.landscapeRight)

                ContentView()
                    .previewDevice(PreviewDevice(rawValue: PreviewDevice.PhoneDevices.eight.rawValue))
            }
        }
    }
}
