//
//  InteractiveConesView.swift
//  MySight
//
//  Created by Warren Gavin on 19/05/2022.
//

import SwiftUI

struct InteractiveConesView: View {
    @State private var blueScale: Double = 1
    @State private var redScale: Double = 1
    @State private var greenScale: Double = 1

    @State private var cvd = CVDProfile(name: "", cvd: .deutan, severity: 0.0)

    private let axisThickness: CGFloat = 0.3

    var body: some View {
        VStack {
            graphView
                .padding(.bottom, 12)
                .onAppear {
                    animateValues()
                }

            Text(simulationDescription)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

private extension InteractiveConesView {
    var simulationDescription: String {
        switch (blueScale, redScale, greenScale) {
        case (1, 1, 1):
            return "Normal Colour Vision"

        default:
            return cvd.description
        }
    }

    var graphView: some View {
        HStack(spacing: 0) {
            Color.primary
                .frame(maxWidth: axisThickness)
            
            VStack(spacing: 0) {
                HStack {
                    BellCurveView(scale: $blueScale, color: .blue)

                    BellCurveView(scale: $redScale, color: .red)

                    BellCurveView(scale: $greenScale, color: .green)
                }
                
                Color.primary
                    .frame(maxHeight: axisThickness)
                    .padding(.bottom, 1)
            }
        }
    }

    func animateValues() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            withAnimation(.spring(response: 0.7, blendDuration: 0.5)) {
                blueScale = Double.random(in: 0.01...0.8)
                redScale = 1.0
                greenScale = 1.0
            }

            cvd = CVDProfile(name: "", cvd: .tritan, severity: Float(1 - blueScale))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            withAnimation(.spring(response: 0.7, blendDuration: 0.5)) {
                blueScale = 1.0
                redScale = Double.random(in: 0.01...0.8)
                greenScale = 1.0
            }

            cvd = CVDProfile(name: "", cvd: .protan, severity: Float(1 - redScale))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            withAnimation(.spring(response: 0.7, blendDuration: 0.5)) {
                blueScale = 1.0
                redScale = 1.0
                greenScale = Double.random(in: 0.01...0.8)
            }

            cvd = CVDProfile(name: "", cvd: .deutan, severity: Float(1 - greenScale))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8)) {
            let randomCVD = CVD.allCases.randomElement() ?? .deutan

            withAnimation(.spring(response: 0.7, blendDuration: 0.5)) {
                blueScale = (randomCVD == .tritan ? 0.0 : 1.0)
                redScale = (randomCVD == .protan ? 0.0 : 1.0)
                greenScale = (randomCVD == .deutan ? 0.0 : 1.0)
            }

            cvd = CVDProfile(name: "", cvd: randomCVD, severity: 1)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
            withAnimation(.spring(response: 0.7, blendDuration: 0.5)) {
                blueScale = 1.0
                redScale = 1.0
                greenScale = 1.0
            }

            animateValues()
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
                .previewLayout(.fixed(width: 500, height: 300))
                .padding()
            
            InteractiveConesView()
                .previewLayout(.fixed(width: 500, height: 300))
                .padding()
                .preferredColorScheme(.dark)
        }
    }
}
