//
//  BaseTextField.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 17/04/2026.
//

import SwiftUI

struct BaseTextField: View {
    let title: String
    @Binding var text: String
    
    private var keyboardType: UIKeyboardType = .default
    private var submitLabel: SubmitLabel = .done
    private var textContentType: UITextContentType? = nil
    private var textInputAutocapitalization: TextInputAutocapitalization? = .never
    private var autocorrectionDisabled: Bool = true
    private var onSubmit: () -> Void = {}
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        TextField(title, text: $text)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.lightNavy.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.navy, lineWidth: 1)
                    )
            }
            .keyboardType(keyboardType)
            .submitLabel(submitLabel)
            .autocorrectionDisabled(autocorrectionDisabled)
            .textContentType(textContentType)
            .textInputAutocapitalization(textInputAutocapitalization)
            .onSubmit {
                onSubmit()
            }
    }
    
    func keyboardType(_ type: UIKeyboardType) -> BaseTextField {
        var copy = self
        copy.keyboardType = type
        return copy
    }
    
    func submitLabel(_ label: SubmitLabel) -> BaseTextField {
        var copy = self
        copy.submitLabel = label
        return copy
    }
    
    func textContentType(_ textContentType: UITextContentType?) -> BaseTextField {
        var copy = self
        copy.textContentType = textContentType
        return copy
    }
    
    func textInputAutocapitalization(_ textInputAutocapitalization: TextInputAutocapitalization?) -> BaseTextField {
        var copy = self
        copy.textInputAutocapitalization = textInputAutocapitalization
        return copy
    }
    
    func autocorrectionDisabled(_ autocorrectionDisabled: Bool) -> BaseTextField {
        var copy = self
        copy.autocorrectionDisabled = autocorrectionDisabled
        return copy
    }
    
    func onSubmit(_ onSubmit: @escaping () -> Void) -> BaseTextField {
        var copy = self
        copy.onSubmit = onSubmit
        return copy
    }
}

#Preview {
    BaseTextField("Maciej", text: .constant("Text"))
}
