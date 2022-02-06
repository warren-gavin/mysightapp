//
//  TechnicalTermsHelpView.swift
//  MySight
//
//  Created by Warren Gavin on 01/02/2022.
//

import SwiftUI

struct TechnicalTermsHelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("What's all this?")
                    .condensible(style: .title, weight: .black)
                    .padding(.vertical, 12)

                Text("""
Too much jargon to begin with? What's a *Deutan*? Why is there a slider? And what's 'Anomalous Trichromacy' supposed to mean? Let's break it down.

**Trichromacy**

""")
            }
            .padding(.horizontal, 12)
        }
    }
}

struct TechnicalTermsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        TechnicalTermsHelpView()
    }
}
