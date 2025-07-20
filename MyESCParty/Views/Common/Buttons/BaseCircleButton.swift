//
//  BaseCircleButton.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 20/07/2025.
//

import SwiftUI

struct BaseCircleButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Circle()
                .fill(.navy)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: imageName)
                        .foregroundStyle(.white)
                )
        }
    }
}

#Preview {
    BaseCircleButton(imageName: "plus") {
        
    }
}
