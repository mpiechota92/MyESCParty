//
//  AuthViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/06/2025.
//

import Foundation
import Supabase

class AuthViewModel: BaseViewModel {
    @Published var isSessionActive: Bool = false
    @Published var user: AppUser? = nil
    
    private let authManager = AuthManager.shared
    //private let validatorManager = ValidatorManager.shared
    
    override init() {
        super.init()
        refreshSession()
    }
    
    func refreshSession() {
        isSessionActive = authManager.isSessionActive
    }
    
    @MainActor
    func signIn(email: String, password: String) async {
        performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            let user = try await self.authManager.signInWith(email: email, password: password)
            self.user = user
            self.isSessionActive = true
        }
    }
    
    @MainActor
    func signUp(email: String, username: String, password: String) async {
        performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            let user = try await self.authManager.signUpWith(email: email, username: username, password: password)
            self.user = user
            self.isSessionActive = false
        }
    }
    
    @MainActor
    func signOut() async {
        performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            try await self.authManager.signOut()
            self.isSessionActive = false
            self.user = nil
        }
    }
}
