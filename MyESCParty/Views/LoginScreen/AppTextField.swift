//
//  AppTextField.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

struct AppTextField: View {
    let promptText: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text.isEmpty ? "" : promptText)
                .padding(.leading, 15)
                .padding(.top, 10)
                .font(.system(size: 15.0))
            ZStack {
                TextField(promptText, text: $text)
                    .foregroundStyle(.yellow, .green, .pink)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .frame(height: 50)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.lightNavy)
                            .frame(height: 50)
                    )
            }
        }
        .padding(10)
    }
}

#Preview {
    AppTextField(promptText: "Prompt Text", text: .constant(""))
}
