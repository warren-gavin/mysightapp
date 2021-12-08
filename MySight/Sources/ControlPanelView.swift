//
//  ControlPanelView.swift
//  MySight
//
//  Created by Warren Gavin on 12/11/2021.
//

import SwiftUI

struct ControlPanelView: View {
    @EnvironmentObject var profileManager: CVDProfileManager
    @Environment(\.sizeCategory) var sizeCategory

    @Binding var cvd: CVD
    @Binding var severity: Float
    @Binding var addNewProfile: Bool
    @Binding var loadImage: Bool

    @State private var deleteProfile: CVDProfile?

    var body: some View {
        VStack {
            actionControls
                .padding(.horizontal, 20.0)
            
            profileButtons
        }
        .frame(maxWidth: 400)
        .fixedSize(horizontal: false, vertical: true)
    }
}

private extension ControlPanelView {
    var actionButtons: some View {
        HStack {
            Button {
                addNewProfile = true
            } label: {
                Image(systemName: "plus")
            }
            .imageStyle()

            Button {
                loadImage = true
            } label: {
                Image(systemName: "photo.on.rectangle.angled")
            }
            .imageStyle()
        }
    }

    var actionControls: some View {
        Group {
            Slider(value: $severity, in: 0.0 ... 1.0)
                .frame(minWidth: 170)
            
            actionButtons
        }
        .modifier(
            Stacker(spacing: 12,
                    useVerticalAlignment: sizeCategory.isAccessibilityCategory)
        )
    }

    func profileButtonName(for profile: CVDProfile) -> String {
        guard let accessibilityAbbreviation = profile.accessibilityAbbreviation else {
            return profile.name
        }

        return sizeCategory.isAccessibilityCategory ? accessibilityAbbreviation : profile.name
    }

    @ViewBuilder
    func standardProfiles() -> some View {
        VStack(spacing: 4) {
            if profileManager.savedProfilesExist {
                HStack {
                    Text("DICHROMAT SETTINGS")
                        .font(.caption)
                    Spacer()
                }
            }

            HStack {
                ForEach(profileManager.standardProfiles, id: \.name) { profile in
                    Button(profileButtonName(for: profile)) {
                        cvd = profile.cvd
                        profileManager.activeProfile = profile
                    }
                    .accessibilityLabel(profile.name)
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
                Text("SAVED SETTINGS")
                    .font(.caption)
                Spacer()
            }
            .padding(.horizontal, 20.0)


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(profileManager.savedProfiles, id: \.name) { profile in
                        HStack {
                            Button(profile.name) {
                                cvd = profile.cvd
                                severity = profile.severity
                                profileManager.activeProfile = profile
                            }
                            .modifier(ProfileButton(profile: profile,
                                                    activeProfile: profileManager.activeProfile))

                            Button {
                                deleteProfile = profile
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .iconStyle()
                            }
                            .alert(item: $deleteProfile) { profileToDelete in
                                Alert(title: Text("Delete setting?"),
                                      message: Text("Are you sure you want to delete this setting?"),
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
}

private struct ProfileButton: ViewModifier {
    let profile: CVDProfile
    let activeProfile: CVDProfile

    var buttonBackground: Color {
        profile == activeProfile ? .accentColor : .clear
    }

    var textColor: Color {
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
                             severity: .constant(0.95),
                             addNewProfile: .constant(false),
                             loadImage: .constant(false))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)

            ControlPanelView(cvd: .constant(.tritan),
                             severity: .constant(0.6),
                             addNewProfile: .constant(false),
                             loadImage: .constant(false))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .background(Color.gray)
        .environmentObject(manager)
    }
}
