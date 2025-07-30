//
//  LocalAuthManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

class LocalAuthManager: AuthManagerProtocol {
    private let appUser = AppUser(uid: UUID().uuidString, email: nil, username: "username")
    var isSessionActive: Bool { true }
    
    func signInWith(email: String, password: String) async throws -> AppUser {
        appUser
    }
    
    func signUpWith(email: String, username: String, password: String) async throws -> AppUser {
        appUser
    }
    
    func signOut() async throws {
        
    }
    
    func getUserUUID() -> UUID? {
        nil
    }
}
