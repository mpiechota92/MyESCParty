//
//  InLineLoadingView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 17/07/2025.
//

import SwiftUI

struct InLineLoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .tint(.navy)
            Spacer()
        }
    }
}

#Preview {
    InLineLoadingView()
}
