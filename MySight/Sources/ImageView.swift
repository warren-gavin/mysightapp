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
                    .padding(4)
                    .background(Color.black)
                    .foregroundColor(.white)
            }

            ZStack(alignment: .topLeading) {
                filteredImageView?
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Text(CVDProfile(name: "", cvd: cvd, severity: severity).description)
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
                                .padding(.bottom, 12)
//                                .frame(minHeight: 400)
                        } onSharingTypeSelected: { bounds in
                            sharing = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                let scaledBounds = sharedImageSize(boundedTo: bounds)
                                let snap = sharingView
                                    .frame(width: scaledBounds.width, height: scaledBounds.height)
                                    .snapshot()
                                self.item = ActivityItem(items: snap)
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
