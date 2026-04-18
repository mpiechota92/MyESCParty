//
//  View+applyIfLet.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 18/04/2026.
//

import SwiftUI

extension View {
    @ViewBuilder
    func applyIfLet<T>(
        _ value: T?,
        transform: (Self, T) -> some View
    ) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
}
