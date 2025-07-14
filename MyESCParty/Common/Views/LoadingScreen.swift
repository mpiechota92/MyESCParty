//
//  LoadingScreen.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 14/07/2025.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(1.5)
                .tint(.navy)
        }
    }
}

#Preview {
    LoadingScreen()
}
