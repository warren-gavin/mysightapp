//
//  StaticConesView.swift
//  MySight
//
//  Created by Warren Gavin on 07/06/2022.
//

import SwiftUI

struct StaticConesView: View {
    let blueScale: Double
    let redScale: Double
    let greenScale: Double

    init(blueScale: Double = 1,
         redScale: Double = 1,
         greenScale: Double = 1) {
        self.blueScale = blueScale
        self.redScale = redScale
        self.greenScale = greenScale
    }

    var body: some View {
        HStack(spacing: 0) {
            Color.primary
                .frame(maxWidth: 0.3)

            VStack(spacing: 0) {
                HStack {
                    BellCurveView(scale: .constant(blueScale), color: .blue)
                    BellCurveView(scale: .constant(redScale), color: .red)
                    BellCurveView(scale: .constant(greenScale), color: .green)
                }

                Color.primary
                    .frame(maxHeight: 0.3)
            }
        }
    }
}

struct StaticConesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StaticConesView()
                .previewLayout(.fixed(width: 500, height: 300))
                .padding()

            StaticConesView(blueScale: 0.3, redScale: 0.7, greenScale: 1)
                .previewLayout(.fixed(width: 500, height: 300))
                .padding()
                .preferredColorScheme(.dark)
        }
    }
}
