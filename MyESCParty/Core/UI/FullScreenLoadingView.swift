//
//  FullScreenLoadingView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 17/07/2025.
//

import SwiftUI

struct FullScreenLoadingView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(1.5)
                .tint(.navy)
        }
    }
}

#Preview {
    FullScreenLoadingView()
}
