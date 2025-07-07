//
//  AuthManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import Foundation
import Supabase

class AuthManager {
    private static let instance = AuthManager()
    private let databaseManager: DatabaseManager = DatabaseManager.shared
    
    public var isSessionActive: Bool {
        if let _ = databaseManager.client.auth.currentSession {
            return true
        }
        
        return false
    }
    
    public static var shared: AuthManager {
        return instance
    }
    
    private init() { }
    
    func signInWith(email: String, password: String) async throws -> AppUser {
        let session = try await databaseManager.client.auth.signIn(email: email, password: password)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    func signUpWith(email: String, password: String) async throws -> AppUser {
        let response = try await databaseManager.client.auth.signUp(email: email, password: password)
        if let session = response.session {
            return AppUser(uid: session.user.id.uuidString, email: session.user.email)
        }
        
        throw NSError()
    }
    
    func signOut() async throws {
        try await databaseManager.client.auth.signOut()
    }
    
    func getUserId() -> String? {
        guard isSessionActive else { return nil }
        
        return databaseManager.client.auth.currentUser?.id.uuidString
    }
}
