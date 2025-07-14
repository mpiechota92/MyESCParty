//
//  AuthManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import Foundation
import Supabase

enum AuthorizationError: LocalizedError {
    case profileNotFound
    case usernameCreationFailed
    
    var errorDescription: String? {
        switch self {
        case .profileNotFound:
            "Profile not found."
        case .usernameCreationFailed:
            "Username creation failed."
        }
    }
}

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
        
        let profiles: [Profile] = try await databaseManager.client
            .from(.profiles)
            .select()
            .eq("id", value: session.user.id.uuidString)
            .execute()
            .value
        
        guard let profile = profiles.first else {
            try await signOut()
            throw AuthorizationError.profileNotFound
        }
        
        return AppUser(uid: session.user.id.uuidString, email: session.user.email, username: profile.username)
    }
    
    func signUpWith(email: String, username: String, password: String) async throws -> AppUser {
        let response = try await databaseManager.client.auth.signUp(email: email, password: password)
        if let session = response.session {
            let insertData: [String: String] = [
                "id": session.user.id.uuidString,
                "username": username
            ]
            
            let profiles: [Profile] = try await databaseManager.client
                .from(.profiles)
                .insert(insertData)
                .select()
                .execute()
                .value
            
            guard let profile = profiles.first else {
                try await signOut()
                throw AuthorizationError.usernameCreationFailed
            }
            
            return AppUser(uid: session.user.id.uuidString, email: session.user.email, username: profile.username)
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
