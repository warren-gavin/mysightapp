//
//  ImageSharingView.swift
//  MySight
//
//  Created by Warren Gavin on 09/02/2022.
//

import SwiftUI

struct ImageSharingView: View {
    let image: UIImage
    let onScaleSelected: (Double) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Share this image")
                    .condensible(style: .title, weight: .bold)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 18)

                Spacer()

                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 12)
                    .frame(minHeight: 400)

                Spacer()

                ForEach(SharingType.allCases) { sharingType in
                    Button {
                        onScaleSelected(sharingType.scale(for: image))
                    } label: {
                        Text(sharingType.description)
                            .condensible()
                    }
                    .modifier(SharingButton())
                }
                .padding(.bottom, 24)
            }
            .frame(width: 450)
        }
    }
}

private enum SharingType: CaseIterable, Identifiable {
    case social
    case email
    case large

    var id: String {
        description.localized
    }

    var description: LocalizedStringKey {
        switch self {
        case .social:
            return "Small (Social Media)"

        case .email:
            return "Medium (Email)"

        case .large:
            return "Large (Many MBs)"
        }
    }

    func scale(for image: UIImage) -> Double {
        guard let imageSize = image.pngData()?.count else {
            fatalError("No image data")
        }

        let preferredScale: (Int) -> Double = { maxSize in
            if imageSize < maxSize {
                return 1.0
            }

            print(Double(maxSize) / Double(imageSize))
            return Double(maxSize) / Double(imageSize)
        }

        switch self {
        case .social:
            return preferredScale(500_000)

        case .email:
            return preferredScale(1_000_000)

        case .large:
            return preferredScale(2_000_000)
        }
    }
}

private struct SharingButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .frame(maxWidth: 300)
            .background(Color.accentColor)
            .foregroundColor(.background)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .padding(1)
            .padding(.horizontal, 11)
    }
}

struct ImageSharingView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSharingView(image: UIImage(named: "app-store-preview-1")!) { _ in }
            .preferredColorScheme(.dark)
    }
}
