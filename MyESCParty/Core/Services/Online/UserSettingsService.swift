//
//  UserSettingsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import Foundation

enum UserSettingsServiceError: Error {
    case nameDuplicated
    case nameUpdateFailure
    case missingUserID
}

class UserSettingsService: UserSettingsServiceProtocol {
    private let databaseManager: DatabaseManager = DatabaseManager.shared
    
    func changeName(newName: String, for userID: String?) async throws -> Profile {
        guard let userID else {
            throw UserSettingsServiceError.missingUserID
        }
        print(userID)
        
        let profiles: [Profile] = try await databaseManager.client
            .from(.profiles)
            .select()
            .eq("username", value: newName)
            .execute()
            .value
        
        guard profiles.isEmpty else {
            throw UserSettingsServiceError.nameDuplicated
        }
        
        let updateData: [String: String] = [
            "username": newName
        ]
        
        let updatedProfiles: [Profile] = try await databaseManager.client
            .from(.profiles)
            .update(updateData)
            .eq("id", value: UUID(uuidString: userID))
            .select()
            .execute()
            .value
        
        guard let profile = updatedProfiles.first else {
            throw UserSettingsServiceError.nameUpdateFailure
        }
        
        return profile
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
