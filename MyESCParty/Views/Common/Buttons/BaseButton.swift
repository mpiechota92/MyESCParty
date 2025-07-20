//
//  BaseButton.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 20/07/2025.
//

import SwiftUI

struct BaseButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.navy)
                .cornerRadius(10)
        }
    }
}

#Preview {
    BaseButton(title: "Press me") {}
}
