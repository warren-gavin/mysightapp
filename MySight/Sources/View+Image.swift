//
//  View+Image.swift
//  MySightPOC
//
//  Created by Warren Gavin on 12/11/2021.
//

import SwiftUI

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.loadView()

        let view = controller.view!
        let contentSize = view.intrinsicContentSize

        view.bounds = CGRect(origin: .zero, size: contentSize)
        view.backgroundColor = .clear

        return UIGraphicsImageRenderer(size: contentSize).image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}
