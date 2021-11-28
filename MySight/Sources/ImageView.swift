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
                        Spacer()
                        Button {
                            self.image = nil
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 24.0))
                        }
                    }
                    .padding(.top, 54)
                    .padding(.horizontal, 12)

                    Spacer()

                    CVDImageSimulationView(image: image,
                                           cvd: $cvd,
                                           severity: $severity)
                        .padding(.top, 34)

                    Spacer()
                }
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(image: .constant(nil),
                  cvd: .constant(.deutan),
                  severity: .constant(1.0))
    }
}
