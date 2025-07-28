//
//  UserMenuViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 23/07/2025.
//

import Foundation

class UserMenuViewModel: BaseViewModel {
    @MainActor
    func signOut(authViewModel: AuthViewModel) async {
        await performWithLoading(type: .fullScreen) {
            try await authViewModel.signOut()
        }
    }
}
