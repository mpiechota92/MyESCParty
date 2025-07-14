//
//  AuthViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/06/2025.
//

import Foundation
import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isSessionActive: Bool = false
    @Published var isLoading: Bool = false
    @Published var user: AppUser? = nil
    @Published var error: AuthError? = nil
    
    private let authManager = AuthManager.shared
    
    init() {
        refreshSession()
    }
    
    func refreshSession() {
        isSessionActive = authManager.isSessionActive
    }
    
    func signIn(email: String, password: String) async {
        self.isLoading = true
        
        do {
            let user = try await authManager.signInWith(email: email, password: password)
            self.user = user
            self.isSessionActive = true
            self.isLoading = false
        } catch {
            print(error.localizedDescription)
            print("\(error)")
            if let error = error as? AuthError {
                self.error = error
            } else {
                self.error = .api(
                    message: "Unknown error while signing in",
                    errorCode: .unknown,
                    underlyingData: Data(),
                    underlyingResponse: HTTPURLResponse()
                )
            }
            
            self.isSessionActive = false
            self.isLoading = false
        }
    }
    
    func signUp(email: String, username: String, password: String) async {
        self.isLoading = true
        
        do {
            let user = try await authManager.signUpWith(email: email, username: username, password: password)
            self.user = user
            self.isSessionActive = false
            self.isLoading = false
        } catch {
            if let error = error as? AuthError {
                self.error = error
            } else {
                self.error = .api(
                    message: error.localizedDescription,
                    errorCode: .unknown,
                    underlyingData: Data(),
                    underlyingResponse: HTTPURLResponse()
                )
            }
            
            self.isSessionActive = false
            self.isLoading = false
        }
    }
    
    func signOut() async {
        self.isLoading = true
        
        do {
            try await authManager.signOut()
            self.isSessionActive = false
            self.user = nil
            self.isLoading = false
        } catch {
            print(error.localizedDescription)
            if let error = error as? AuthError {
                self.error = error
            } else {
                self.error = .api(
                    message: "Unknown error while signing out",
                    errorCode: .unknown,
                    underlyingData: Data(),
                    underlyingResponse: HTTPURLResponse()
                )
            }
            
            self.isLoading = false
        }
    }
}
