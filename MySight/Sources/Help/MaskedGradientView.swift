//
//  MaskedGradientView.swift
//  MySight
//
//  Created by Warren Gavin on 19/05/2022.
//

import SwiftUI

struct MaskedGradientView<S: Shape>: View {
    let shape: S
    let color: Color

    var body: some View {
        LinearGradient(colors: [color, color.opacity(0.2)],
                       startPoint: .top,
                       endPoint: .bottom)
            .mask(shape)
    }
}

struct MaskedGradientView_Previews: PreviewProvider {
    static var previews: some View {
        MaskedGradientView(shape: Circle(), color: .red)
            .padding()
    }
}
