//
//  Stacker.swift
//  MySight
//
//  Created by Warren Gavin on 29/11/2021.
//

import SwiftUI

struct Stacker: ViewModifier {
    let spacing: Double
    let useVerticalAlignment: () -> Bool

    init(spacing: Double,
         useVerticalAlignment: @escaping () -> Bool) {
        self.spacing = spacing
        self.useVerticalAlignment = useVerticalAlignment
    }

    @ViewBuilder
    func body(content: Content) -> some View {
        if useVerticalAlignment() {
            VStack(spacing: spacing) {
                content
            }
        }
        else {
            HStack(spacing: spacing) {
                content
            }
        }
    }
}

extension View {
    func embedInStack(spacing: Double = 0, useVerticalAlignment: @autoclosure @escaping () -> Bool) -> some View {
        modifier(Stacker(spacing: spacing, useVerticalAlignment: useVerticalAlignment))
    }
}
