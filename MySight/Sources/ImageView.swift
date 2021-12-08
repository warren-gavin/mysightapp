//
//  ImageView.swift
//  MySight
//
//  Created by Warren Gavin on 21/11/2021.
//

import SwiftUI
import ActivityView

struct ImageView: View {
    @Binding var image: UIImage?
    @Binding var cvd: CVD
    @Binding var severity: Float

    @State private var item: ActivityItem?
    @State private var sharing = false

    var body: some View {
        if let image = image {
            ZStack {
                Color.background

                VStack {
                    HStack {
                        Button {
                            sharing = true
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .iconStyle()
                        }
                        .activitySheet($item)
                        .actionSheet(isPresented: $sharing) {
                            ActionSheet(title: Text("Share this image"),
                                        message: Text("Choose a file size"),
                                        buttons: [
                                .default(Text("Small (\(image.sizeEstimate(scaledTo: 0.1)))")) {
                                    share(image: image, scaledTo: 0.1)
                                },
                                .default(Text("Medium (\(image.sizeEstimate(scaledTo: 0.3)))")) {
                                    share(image: image, scaledTo: 0.3)
                                },
                                .default(Text("Large (\(image.sizeEstimate(scaledTo: 0.6)))")) {
                                    share(image: image, scaledTo: 0.6)
                                },
                                .cancel {
                                    sharing = false
                                }
                            ])
                        }

                        Spacer()

                        Button {
                            self.image = nil
                        } label: {
                            Image(systemName: "xmark.circle")
                                .iconStyle()
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 20)

                    Spacer()

                    filteredImageView?
                        .resizable()
                        .aspectRatio(contentMode: .fit)

                    Spacer()
                }
            }
        }
    }
}

private extension ImageView {
    var filteredImage: UIImage? {
        guard let image = image else {
            return nil
        }

        let filter = CVDFilter(cvd: cvd, severity: severity)
        return filter.filteredImage(with: image)
    }

    var filteredImageView: Image? {
        guard let filteredImage = filteredImage else {
            return nil
        }

        return Image(uiImage: filteredImage)
    }

    func combined(images: UIImage..., texts: String..., scaledTo scaleFactor: CGFloat) -> UIImage? {
        let originalSize = images.reduce(into: CGSize.zero) { partialResult, image in
            partialResult = CGSize(width: partialResult.width + image.size.width,
                                   height: image.size.height)
        }

        let size = CGSize(width: originalSize.width * scaleFactor,
                          height: originalSize.height * scaleFactor)

        let image = UIGraphicsImageRenderer(size: size).image { _ in
            images.enumerated().forEach { (idx, image) in
                let imageRect = CGRect(origin: CGPoint(x: image.size.width * scaleFactor * CGFloat(idx), y: 0),
                                       size: CGSize(width: image.size.width * scaleFactor,
                                                    height: image.size.height * scaleFactor))
                image.draw(in: imageRect)
                texts[safe: idx]?.draw(in: imageRect, scaleTo: scaleFactor)
            }
        }

        return image
    }

    func share(image: UIImage, scaledTo scaleFactor: Double) {
        let profile = CVDProfile(name: "",
                                 cvd: cvd,
                                 severity: severity)

        if let filteredImage = filteredImage,
           let shareImage = combined(images: image, filteredImage,
                                     texts: NSLocalizedString("Normal Colour Vision", comment: ""),
                                            profile.description,
                                     scaledTo: scaleFactor) {
            item = ActivityItem(items: shareImage)
        }
    }
}

private extension UIImage {
    func sizeEstimate(scaledTo scaleFactor: CGFloat) -> String {
        let screenScale = UIScreen.main.scale
        return "\(Int(size.width * 2 * screenScale * scaleFactor)) x \(Int(size.height * screenScale * scaleFactor))"
    }
}

private extension String {
    func draw(in rect: CGRect, scaleTo scaleFactor: CGFloat) {
        let font = UIFont(name: "Arial", size: 48 * scaleFactor)!
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
            ImageView(image: .constant(UIImage(named: "app-store-preview-1")),
                      cvd: .constant(.deutan),
                      severity: .constant(1.0))
                .previewDevice($0)
        }
    }
}
