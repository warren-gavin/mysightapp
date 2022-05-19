//
//  InteractiveConesView.swift
//  MySight
//
//  Created by Warren Gavin on 19/05/2022.
//

import SwiftUI

class InteractiveConesViewModel: ObservableObject {
    private var _blueScale: Double = 1
    private var _redScale: Double = 1
    private var _greenScale: Double = 1

    var blueScale: Double {
        get {
            _blueScale
        }

        set {
            _blueScale = newValue
            _redScale = 1
            _greenScale = 1

            objectWillChange.send()
        }
    }

    var redScale: Double {
        get {
            _redScale
        }

        set {
            _blueScale = 1
            _redScale = newValue
            _greenScale = 1

            objectWillChange.send()
        }
    }

    var greenScale: Double {
        get {
            _greenScale
        }

        set {
            _blueScale = 1
            _redScale = 1
            _greenScale = newValue

            objectWillChange.send()
        }
    }
}

struct InteractiveConesView: View {
    @ObservedObject var viewModel = InteractiveConesViewModel()

    private let axisThickness: CGFloat = 0.3

    var body: some View {
        HStack(spacing: 0) {
            Color.primary
                .frame(maxWidth: axisThickness)

            VStack(spacing: 0) {
                HStack {
                    BellCurveView(scale: viewModel.blueScale, color: .blue)
                    BellCurveView(scale: viewModel.redScale, color: .red)
                    BellCurveView(scale: viewModel.greenScale, color: .green)
                }

                Color.primary
                    .frame(maxHeight: axisThickness)
            }
        }
    }
}

extension Color: Identifiable {
    public var id: String {
        description
    }
}

struct InteractiveConesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InteractiveConesView()
                .previewLayout(.fixed(width: 500, height: 200))
                .padding()

            InteractiveConesView()
                .previewLayout(.fixed(width: 500, height: 200))
                .padding()
                .preferredColorScheme(.dark)
        }
    }
}
