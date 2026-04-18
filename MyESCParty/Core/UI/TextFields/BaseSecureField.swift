//
//  BaseSecureField.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 17/04/2026.
//

import SwiftUI

struct BaseSecureField: View {
    let title: String
    @Binding var text: String
    
    private var textContentType: UITextContentType? = nil
    private var submitLabel: SubmitLabel = .done
    private var onSubmit: () -> Void = { }
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        SecureField(title, text: $text)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.lightNavy.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.navy, lineWidth: 1)
                    )
            }
            .textContentType(textContentType)
            .submitLabel(submitLabel)
            .onSubmit {
                onSubmit()
            }
    }
    
    func textContentType(_ type: UITextContentType?) -> BaseSecureField {
        var copy = self
        copy.textContentType = type
        return copy
    }
    
    func submitLabel(_ label: SubmitLabel) -> BaseSecureField {
        var copy = self
        copy.submitLabel = label
        return copy
    }
    
    func onSubmit(_ onSubmit: @escaping () -> Void) -> BaseSecureField {
        var copy = self
        copy.onSubmit = onSubmit
        return copy
    }
    
}

#Preview {
    BaseSecureField("Password", text: .constant(""))
}
