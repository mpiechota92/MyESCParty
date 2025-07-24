//
//  MockAuthManger.swift
//  MyESCPartyTests
//
//  Created by Maciej Piechota on 24/07/2025.
//

import Foundation
@testable import MyESCParty

class MockAuthManger: AuthManagerProtocol {
    private let userUUID = UUID()
    
    var isSessionActive: Bool = false
    
    func signUpWith(email: String, username: String, password: String) async throws -> AppUser {
        isSessionActive = true
        return AppUser(uid: userUUID.uuidString, email: email, username: username)
    }
    
    func signInWith(email: String, password: String) async throws -> AppUser {
        isSessionActive = true
        return AppUser(uid: userUUID.uuidString, email: email, username: "MockUser")
    }
    
    func signOut() async throws {
        isSessionActive = false
    }
    
    func getUserUUID() -> UUID? {
        return userUUID
    }
}
