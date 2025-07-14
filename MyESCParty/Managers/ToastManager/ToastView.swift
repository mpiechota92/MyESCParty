//
//  ToastView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 14/07/2025.
//

import SwiftUI

struct ToastView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var toastManager: ToastManager
    
    @State private var task: Task<Void, Never>? = nil
    
    let toast: Toast
    
    var color: Color {
        switch toast.type {
        case .info:
                .yellow
        case .error:
                .red
        case .success:
                .green
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: geometry.frame(in: .global).width - 50, height: 50)
                    .padding()
                    .foregroundStyle(color)
                    .overlay {
                        Text(toast.message)
                            .padding(5)
                    }
            }
            .frame(maxWidth: .infinity)
            .onTapGesture {
                toastManager.dismiss()
            }
        }
    }
}

#Preview {
    ToastView(toast: Toast(message: "This is a test message", type: .error))
}
