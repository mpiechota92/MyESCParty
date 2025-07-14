//
//  ToastHostView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 14/07/2025.
//

import SwiftUI

struct ToastHostView: View {
    @EnvironmentObject var toastManager: ToastManager
    
    var body: some View {
        ZStack {
            if let toast = toastManager.currentToast {
                ToastView(toast: toast)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.6), value: toastManager.currentToast)
    }
}

#Preview {
    ToastHostView()
}
