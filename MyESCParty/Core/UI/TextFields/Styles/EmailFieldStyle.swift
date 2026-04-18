//
//  EmailFieldStyle.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 18/04/2026.
//

import SwiftUI

struct EmailFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .submitLabel(.next)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
    }
}

extension BaseTextField {
    func emailFieldStyle() -> some View {
        modifier(EmailFieldStyle())
    }
}
