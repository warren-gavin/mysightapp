//
//  FlippingView.swift
//  MySight
//
//  Created by Warren Gavin on 01/12/2021.
//

import SwiftUI

struct FlippingView<Content>: View where Content : View {
    private let content: () -> Content
    private let onFlipping: (() -> Void)?
    private let onFlipEnded: (() -> Void)?

    @Binding var flip: Bool

    @State private var progress: CGFloat = 0
    @State private var offset: CGFloat = 0

    @inlinable public init(flip: Binding<Bool>,
                           @ViewBuilder content: @escaping () -> Content,
                           onFlipping: (() -> Void)?,
                           onFlipEnded: (() -> Void)?) {
        self._flip = flip
        self.content = content
        self.onFlipping = onFlipping
        self.onFlipEnded = onFlipEnded
    }

    var body: some View {
        content()
            .blur(radius: 15 * progress)
            .rotation3DEffect(Angle(degrees: rotationAngle), axis: (0, 0.5, 0))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newOffset = gesture.translation.width

                        if abs(offset) < maxOffset && abs(newOffset) >= maxOffset
                            || abs(offset) >= maxOffset && abs(newOffset) < maxOffset {
                            flip.toggle()
                        }

                        offset = newOffset
                        progress = min(abs(offset), maxOffset) / maxOffset

                        onFlipping?()
                    }
                    .onEnded { _ in
                        onFlipEnded?()
                        
                        withAnimation {
                            offset = .zero
                            progress = 0.0
                        }
                    }
            )
    }

    var maxOffset: CGFloat {
        80
    }

    var rotationAngle: Double {
        var o = (abs(offset) + maxOffset).truncatingRemainder(dividingBy: 2 * maxOffset) - maxOffset
        o = offset >= 0 ? o : -o

        return 90 * o / maxOffset

    }
}
