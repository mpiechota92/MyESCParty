//
//  ListOffsetKey.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 20/07/2025.
//

import SwiftUI

struct ListOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
