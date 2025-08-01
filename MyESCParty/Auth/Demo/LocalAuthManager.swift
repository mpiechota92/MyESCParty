//
//  LocalAuthManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

class LocalAuthManager: AuthManagerProtocol {
    private let appUser = AppUser(
        uid: "9a1b2a35-0d07-4313-9cd5-df22f573dd1f",
        email: "test1@mail.com",
        username: "username"
    )
    
    private var isUserSignedIn: Bool = false
    var isSessionActive: Bool {
        isUserSignedIn
    }
    
    func signInWith(email: String, password: String) async throws -> AppUser {
        isUserSignedIn = true
        return appUser
    }
    
    func signUpWith(email: String, username: String, password: String) async throws -> AppUser {
        isUserSignedIn = true
        return appUser
    }
    
    func signOut() async throws {
        isUserSignedIn = false
    }
    
    func getUserUUID() -> UUID? {
        let uuid = UUID(uuidString: appUser.uid)
        return uuid
    }
}
