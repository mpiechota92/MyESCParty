//
//  EscButton.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import SwiftUI

struct EscButton: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
                .stroke(Color.black, lineWidth: 2)
        }
    }
}

#Preview {
    EscButton()
}
