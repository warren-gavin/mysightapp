//
//  ConeGraphView.swift
//  MySight
//
//  Created by Warren Gavin on 19/11/2022.
//

import SwiftUI

struct ConeGraphView: View {
    let label: LocalizedStringKey
    let redScale: Double
    let greenScale: Double
    let blueScale: Double

    init(label: LocalizedStringKey,
         redScale: Double = 1,
         greenScale: Double = 1,
         blueScale: Double = 1) {
        self.label = label
        self.redScale = redScale
        self.greenScale = greenScale
        self.blueScale = blueScale
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                StaticConesView(redScale: redScale,
                                greenScale: greenScale,
                                blueScale: blueScale)
                    .frame(height: 200)
                    .padding(.horizontal, 12)
                Spacer()
            }

            Text(label)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom, 12)
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        ConeGraphView(label: "Graph")
    }
}
