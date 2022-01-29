//
//  ControlPanelView.swift
//  MySight
//
//  Created by Warren Gavin on 12/11/2021.
//

import SwiftUI

struct ControlPanelView: View {
    @EnvironmentObject var profileManager: CVDProfileManager
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    @Binding var cvd: CVD
    @Binding var severity: Float
    @Binding var show: Bool
    @Binding var orientation: UIDeviceOrientation
    @Binding var enableFilter: Bool
    @Binding var showHelp: Bool

    @State private var deleteProfile: CVDProfile?

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Toggle("", isOn: $enableFilter)
                    .tint(Color.accentColor.opacity(0.9))
                    .fixedSize()
                    .padding(.leading, -7)
                Spacer()
                Text(description)
                    .condensible()
                Button {
                    showHelp = true
                } label: {
                    Image(systemName: "questionmark.circle")
                        .iconStyle()
                }
            }
            .padding(.horizontal, show ? 20.0 : 8.0)

            if show {
                Group {
                    actionControls
                        .padding(.horizontal, 20.0)

                    profileButtons
                }.opacity(show ? 1 : 0)
            }
        }
        .fixedSize(horizontal: shouldFixHorizontal, vertical: true)
    }
}

private extension ControlPanelView {
    var description: String {
        if severity > 0.999 {
            return cvd.dichromatName.localized
        }

        if severity < 0.01 {
            return "Normal Colour Vision"
        }

        return "\(Int(severity * 100))% \(cvd.anomalousTrichromatName.localized)"
    }

    var actionControls: some View {
        Slider(value: $severity, in: 0.0 ... 1.0)
            .accessibilityIdentifier("cvd severity")
            .padding(.top, -14)
    }

    func profileButtonName(for profile: CVDProfile) -> String {
        guard let accessibilityAbbreviation = profile.accessibilityAbbreviation else {
            return profile.name
        }

        switch dynamicTypeSize {
        case .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return accessibilityAbbreviation

        default:
            return profile.name
        }
    }

    @ViewBuilder
    func standardProfiles() -> some View {
        VStack(spacing: 4) {
            if profileManager.savedProfilesExist {
                HStack {
                    Text("DICHROMAT PROFILES")
                        .condensible(style: .caption)
                    Spacer()
                }
            }

            HStack {
                ForEach(profileManager.standardProfiles, id: \.name) { profile in
                    Button {
                        cvd = profile.cvd
                        profileManager.activeProfile = profile
                    } label: {
                        Text(profileButtonName(for: profile))
                            .condensible()
                    }
                    .accessibilityIdentifier(profile.name)
                    .modifier(ProfileButton(profile: profile,
                                            activeProfile: profileManager.activeProfile))

                    if profile != profileManager.standardProfiles.last {
                        Spacer()
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 20.0)
    }

    @ViewBuilder
    func savedProfiles() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("SAVED PROFILES")
                    .condensible(style: .caption)
                Spacer()
            }
            .padding(.horizontal, 20.0)


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(profileManager.savedProfiles, id: \.name) { profile in
                        HStack {
                            Button {
                                cvd = profile.cvd
                                severity = profile.severity
                                profileManager.activeProfile = profile
                            } label: {
                                Text(profile.name)
                                    .condensible()
                            }
                            .accessibilityIdentifier(profile.name)
                            .modifier(ProfileButton(profile: profile,
                                                    activeProfile: profileManager.activeProfile))

                            Button {
                                deleteProfile = profile
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .iconStyle()
                            }
                            .accessibilityIdentifier("delete profile")
                            .alert(item: $deleteProfile) { profileToDelete in
                                Alert(title: Text("Delete profile?"),
                                      message: Text("Are you sure you want to delete this profile?"),
                                      primaryButton: .cancel(),
                                      secondaryButton: .destructive(Text("Delete"), action: {
                                    profileManager.remove(profile: profileToDelete)

                                    cvd = profileManager.activeProfile.cvd
                                    severity = profileManager.activeProfile.severity
                                }))
                            }
                        }
                    }
                }
                .padding(.horizontal, 20.0)
            }
        }
    }

    var profileButtons: some View {
        Group {
            standardProfiles()

            if profileManager.savedProfilesExist {
                savedProfiles()
            }
        }
    }

    var shouldFixHorizontal: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }

        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return true

        default:
            return false
        }
    }
}

private struct ProfileButton: ViewModifier {
    let profile: CVDProfile
    let activeProfile: CVDProfile

    private var buttonBackground: Color {
        profile == activeProfile ? .accentColor : .clear
    }

    private var textColor: Color {
        profile == activeProfile ? .background : .accentColor
    }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .background(buttonBackground)
            .foregroundColor(textColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .padding(1)
    }
}

struct ControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CVDProfileManager()
        manager.save(profile: CVDProfile(name: "Test", cvd: .deutan, severity: 0.7))
        manager.save(profile: CVDProfile(name: "Test with long name", cvd: .deutan, severity: 0.7))
        manager.activeProfile = CVDProfile.standardProfiles.first!

        return Group {
            ControlPanelView(cvd: .constant(.deutan),
                             severity: .constant(1),
                             show: .constant(true),
                             orientation: .constant(.portrait),
                             enableFilter: .constant(true),
                             showHelp: .constant(false))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)

//            ControlPanelView(cvd: .constant(.tritan),
//                             severity: .constant(0.6),
//                             show: .constant(true))
//                .preferredColorScheme(.light)
.previewInterfaceOrientation(.portraitUpsideDown)
//                .previewLayout(.sizeThatFits)
//                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .background(Color.gray)
        .environmentObject(manager)
    }
}
