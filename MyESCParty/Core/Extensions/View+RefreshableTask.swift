//
//  View+RefreshableTask.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 26/03/2026.
//

import SwiftUI

extension ScrollView {
    /// A safe refreshable wrapper that avoids SwiftUI cancelling the task on ScrollView redraws.
    func refreshableTask(_ action: @escaping @MainActor () async -> Void) -> some View {
        self.refreshable {
            await Task { await action() }.value
        }
    }
}
