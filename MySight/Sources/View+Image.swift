//
//  View+Image.swift
//  MySight
//
//  Created by Warren Gavin on 12/11/2021.
//

import SwiftUI

extension View {
    func iconStyle() -> some View {
        font(Font.subheadline.weight(.light))
    }

    func imageStyle() -> some View {
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial)
            .foregroundColor(.accentColor)
            .clipShape(Capsule())
            .iconStyle()
            .frame(minWidth: 44, minHeight: 44)
            .fixedSize(horizontal: true, vertical: true)
    }
}
