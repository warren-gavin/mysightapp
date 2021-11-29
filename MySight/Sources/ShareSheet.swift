//
//  ShareSheet.swift
//  MySight
//
//  Created by Warren Gavin on 29/11/2021.
//

import UIKit

struct ShareSheet {
    let items: [Any]

    func show() {
        let activityVC = UIActivityViewController(activityItems: items,
                                                  applicationActivities: nil)

        UIApplication.shared.windows.first?.rootViewController?.present(activityVC,
                                                                        animated: true,
                                                                        completion: nil)
    }
}
