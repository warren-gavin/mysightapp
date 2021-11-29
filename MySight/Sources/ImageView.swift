//
//  ImageView.swift
//  MySight
//
//  Created by Warren Gavin on 21/11/2021.
//

import SwiftUI

struct ImageView: View {
    @Binding var image: UIImage?
    @Binding var cvd: CVD
    @Binding var severity: Float

    var body: some View {
        if let image = image {
            ZStack {
                Color.background

                VStack {
                    HStack {
                        Button {
                            guard let filteredImage = filteredImage else {
                                return
                            }

                            let shareSheet = ShareSheet(items: [image, filteredImage])
                            shareSheet.show()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 24.0))
                        }

                        Spacer()

                        Button {
                            self.image = nil
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 24.0))
                        }
                    }
                    .padding(.top, 54)
                    .padding(.horizontal, 20)

                    Spacer()

                    filteredImageView?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 16)

                    Spacer()
                }
            }
        }
    }
}

private extension ImageView {
    var filteredImageView: Image? {
        guard let filteredImage = filteredImage else {
            return nil
        }

        return Image(uiImage: filteredImage)
    }

    var filteredImage: UIImage? {
        guard let image = image else {
            return nil
        }

        let filter = CVDFilter(cvd: cvd, severity: severity)
        return filter.filteredImage(with: image)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(image: .constant(nil),
                  cvd: .constant(.deutan),
                  severity: .constant(1.0))
    }
}
