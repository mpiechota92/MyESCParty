//
//  UserMenuViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 23/07/2025.
//

import Foundation

class UserMenuViewModel: BaseViewModel {
    @MainActor
    func signOut(authViewModel: AuthViewModel) {
        performWithLoading(type: .fullScreen) {
            try await authViewModel.signOut()
        }
    }
}
