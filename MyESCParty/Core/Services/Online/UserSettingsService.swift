//
//  UserSettingsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import Foundation

class UserSettingsService: UserSettingsServiceProtocol {
    private let databaseManager: DatabaseManager = DatabaseManager.shared
    
    func changeName(newName: String) async throws {
        
    }
    
    func changeProfilePicture(newProfilePicture: Data) async throws {
        
    }
    
    func getUserData(userId id: String) async throws -> String {
        let profiles: [Profile] = try await databaseManager.client
            .from(.profiles)
            .select()
            .eq("id", value: id)
            .execute()
            .value
        
        guard let userName = profiles.first?.username else {
            throw NSError(domain: "Couldn't load user data", code: 0, userInfo: nil)
        }
        
        return userName
    }
}
