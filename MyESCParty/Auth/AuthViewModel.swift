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
    
    
    private let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol = AuthManager.shared) {
        self.authManager = authManager
        super.init()
        refreshSession()
    }
    
    func refreshSession() {
        isSessionActive = authManager.isSessionActive
    }
    
    func signIn(email: String, password: String) async throws {
        let user = try await authManager.signInWith(email: email, password: password)
        self.user = user
        self.isSessionActive = true
    }
    
    func signUp(email: String, username: String, password: String) async throws {
        let user = try await authManager.signUpWith(email: email, username: username, password: password)
        self.user = user
        self.isSessionActive = true
        
    }
    
    func signOut() async throws {
        try await authManager.signOut()
        self.isSessionActive = false
        self.user = nil
    }
    
    func getUserID() -> String? {
        return authManager.getUserUUID()?.uuidString
    }
}
