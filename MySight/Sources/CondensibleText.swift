//
//  CondensibleText.swift
//  MySight
//
//  Created by Warren Gavin on 02/01/2022.
//

import SwiftUI

struct CondensibleText: ViewModifier {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    let font: String
    let condensedFont: String
    let style: Font.TextStyle
    let weight: Font.Weight

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(Font.custom(fontName, size: fontSize(for: style)).weight(weight))
    }
}

extension View {
    func condensible(style: Font.TextStyle = .body, weight: Font.Weight = .medium) -> some View {
        modifier(CondensibleText(font: "AvenirNext-Medium",
                                 condensedFont: "AvenirNextCondensed-Medium",
                                 style: style,
                                 weight: weight))
    }
}

private extension CondensibleText {
    var fontName: String {
        switch dynamicTypeSize {
        case .xxxLarge, .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return condensedFont

        default:
            return font
        }
    }

    func fontSize(for style: Font.TextStyle) -> CGFloat {
        let sizes : [Font.TextStyle: CGFloat] = [
            .largeTitle: 34,
            .title: 28,
            .title2: 22,
            .title3: 20,
            .headline: 17,
            .subheadline: 15,
            .body: 17,
            .callout: 16,
            .footnote: 15,
            .caption: 12,
            .caption2: 11
        ]

        return sizes[style] ?? 17
    }
}
