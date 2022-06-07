//
//  BellCurveView.swift
//  MySight
//
//  Created by Warren Gavin on 19/05/2022.
//

import SwiftUI

struct BellCurveView: View {
    @Binding var scale: Double
    let color: Color

    var body: some View {
        MaskedGradientView(shape: BellCurve(scale: CGFloat(scale)),
                           color: color)
    }
}

private struct BellCurve: Shape {
    private(set) var scale: CGFloat

    var animatableData: CGFloat {
        get {
            scale
        }

        set {
            scale = newValue
        }
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: 0, y: scale))
        path.addCurve(to: CGPoint(x: 0.5, y: 0),
                      controlPoint1: CGPoint(x: 0.3, y: scale),
                      controlPoint2: CGPoint(x: 0.2, y: 0))
        path.addCurve(to: CGPoint(x: 1, y: scale),
                      controlPoint1: CGPoint(x: 0.8, y: 0),
                      controlPoint2: CGPoint(x: 0.7, y: scale))
        path.addLine(to: CGPoint(x: 0, y: scale))

        return Path(path.cgPath)
            .applying(
                CGAffineTransform(scaleX: rect.width, y: rect.height)
            )
            .applying(
                CGAffineTransform(translationX: 0, y: rect.height * (1 - scale))
            )
    }
}

struct BellCurveView_Previews: PreviewProvider {
    static var previews: some View {
        BellCurveView(scale: .constant(0.85), color: .red)
            .previewLayout(.fixed(width: 300, height: 600))
    }
}
