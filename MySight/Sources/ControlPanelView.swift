//
//  ControlPanelView.swift
//  MySightPOC
//
//  Created by Warren Gavin on 12/11/2021.
//

import SwiftUI

struct ControlPanelView: View {
    @EnvironmentObject var profileManager: CVDProfileManager

    let frame: CGRect
    @Binding var cvd: CVD
    @Binding var severity: Float
    @Binding var addNewProfile: Bool
    @Binding var loadImage: Bool

    func buttonBackground(for profile: CVDProfile) -> Color {
        let activeProfile = profileManager.activeProfile
        return profile == activeProfile ? .background : .clear
    }

    var body: some View {
        if useVerticalAlighment {
            VStack(spacing: 12) {
                actionControls
                profileButtons
            }
        }
        else {
            HStack(spacing: 12) {
                actionControls
                Divider()
                profileButtons
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private extension ControlPanelView {
    var useVerticalAlighment: Bool {
        frame.width < 400
    }

    var actionControls: some View {
        Group {
            HStack {
                Slider(value: $severity, in: 0.0 ... 1.0)

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
    }

    var profileButtons: some View {
        Group {
            HStack {
                ForEach(profileManager.allProfiles, id: \.name) { profile in
                    Button(profile.name) {
                        cvd = profile.cvd
                        severity = profile.severity
                        profileManager.activeProfile = profile
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(buttonBackground(for: profile))
                    .cornerRadius(8)

                    if profile != profileManager.allProfiles.last && useVerticalAlighment {
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ImageButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color.background)
            .clipShape(Capsule())
            .padding(.leading, 12)
    }
}

extension View {
    func imageStyle() -> some View {
        modifier(ImageButton())
    }
}

struct ControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ControlPanelView(frame: CGRect(origin: .zero, size: CGSize(width: 500, height: 30)),
                             cvd: .constant(.deutan),
                             severity: .constant(1.0),
                             addNewProfile: .constant(false),
                             loadImage: .constant(false))
                .preferredColorScheme(.light)
                .previewLayout(.fixed(width: 500, height: 30))

            ControlPanelView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 30)),
                             cvd: .constant(.deutan),
                             severity: .constant(1.0),
                             addNewProfile: .constant(false),
                             loadImage: .constant(false))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
        .background(Color.gray)
        .environmentObject(CVDProfileManager())
    }
}
