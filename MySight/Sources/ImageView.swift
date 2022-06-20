//
//  ImageView.swift
//  MySight
//
//  Created by Warren Gavin on 21/11/2021.
//

import SwiftUI
import ActivityView

struct ImageView: View {
    @Environment(\.presentationMode) var presentationMode

    let image: UIImage

    @Binding var cvd: CVD
    @Binding var severity: Float

    let onDismiss: () -> Void

    @State private var item: ActivityItem?
    @State private var sharing = false

    private func sharingView(from image: UIImage) -> some View {
        Group {
            ZStack(alignment: .topLeading) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Text("Normal colour vision")
                    .font(.footnote)
                    .padding(4)
                    .background(Color.black)
                    .foregroundColor(.white)
            }

            ZStack(alignment: .topLeading) {
                filteredImageView?
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Text(CVDProfile(name: "", cvd: cvd, severity: severity).description)
                    .font(.footnote)
                    .padding(4)
                    .background(Color.black)
                    .foregroundColor(.white)
            }
        }
        .embedInStack(useVerticalAlignment: useVerticalAlignment)
    }

    var body: some View {
        let sharingView = sharingView(from: image)

        return ZStack {
            Color.background

            ZoomedView {
                filteredImageView?
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fit)
            }
            .ignoresSafeArea()

            VStack {
                HStack {
                    Button {
                        sharing = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityIdentifier("share")
                    .imageStyle()
                    .activitySheet($item)
                    .popover(isPresented: $sharing) {
                        SmarterSharingView {
                            sharingView
                        } onSharingTypeSelected: { bounds in
                            sharing = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                share(image: image, boundedTo: bounds)
                            }
                        }
                    }

                    Spacer()

                    Button {
                        onDismiss()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .accessibilityIdentifier("dismiss")
                    .imageStyle()
                }
                .padding(.top, 8)
                .padding(.horizontal, 20)

                Spacer()
            }
        }
    }
}

private extension ImageView {
    func sharedImageSize(boundedTo size: Double) -> CGSize {
        let aspectRatio = (image.size.width * (useVerticalAlignment ? 1 : 2)) / (image.size.height * (useVerticalAlignment ? 2 : 1))
        return CGSize(width: (aspectRatio > 1 ? size : size * aspectRatio),
                      height: (aspectRatio < 1 ? size : size * aspectRatio))
    }

    var useVerticalAlignment: Bool {
        image.size.width > image.size.height
    }

    var filteredImage: UIImage? {
        image.applyCVDFilter(cvd: cvd, severity: severity)
    }

    var filteredImageView: Image? {
        guard let filteredImage = filteredImage else {
            return nil
        }

        return Image(uiImage: filteredImage)
    }

    func combined(images: UIImage..., texts: String..., boundedTo maxWidthOrHeight: Double) -> UIImage? {
        let combinedSize = sharedImageSize(boundedTo: maxWidthOrHeight)

        let scaledImageSize = CGSize(width: combinedSize.width / (useVerticalAlignment ? 1 : 2),
                                     height: combinedSize.height / (useVerticalAlignment ? 2 : 1))

        let image = UIGraphicsImageRenderer(size: combinedSize).image { _ in
            images.enumerated().forEach { (idx, image) in
                let xOffset = (useVerticalAlignment ? 0 : CGFloat(idx) * scaledImageSize.width)
                let yOffset = (useVerticalAlignment ? CGFloat(idx) * scaledImageSize.height : 0)

                let imageRect = CGRect(origin: CGPoint(x: xOffset, y: yOffset),
                                       size: scaledImageSize)
                image.draw(in: imageRect)
                texts[safe: idx]?.draw(in: imageRect)
            }
        }

        return image
    }

    func share(image: UIImage, boundedTo maxWidthOrHeight: Double) {
        let profile = CVDProfile(name: "",
                                 cvd: cvd,
                                 severity: severity)

        if let filteredImage = filteredImage,
           let shareImage = combined(images: image, filteredImage,
                                     texts: NSLocalizedString("Normal Colour Vision", comment: ""),
                                            profile.description,
                                     boundedTo: maxWidthOrHeight) {
            item = ActivityItem(items: shareImage)
        }
    }
}

private extension String {
    func draw(in rect: CGRect) {
        let font = UIFont(name: "Arial", size: 12)!
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.backgroundColor: UIColor.black
        ]

        let string = self as NSString
        let size = string.size(withAttributes: textFontAttributes)
        let textRect = CGRect(origin: rect.origin, size: size)

        string.draw(in: textRect, withAttributes: textFontAttributes)
    }
}







struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            PreviewDevice.twelveProMax,
//            PreviewDevice.eight,
        ], id: \.rawValue) {
            ImageView(image: UIImage(named: "app-store-preview-1")!,
                      cvd: .constant(.deutan),
                      severity: .constant(1.0)) {}
                .previewDevice($0)
        }
    }
}
