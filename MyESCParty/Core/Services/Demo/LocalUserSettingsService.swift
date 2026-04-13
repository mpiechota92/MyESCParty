//
//  LocalUserSettingsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import Foundation

class LocalUserSettingsService: UserSettingsServiceProtocol {
    func changeName(newName: String) async throws {
        
    }
    
    func changeProfilePicture(newProfilePicture: Data) async throws {
        
    }
    
    func getUserData(userId id: String) async throws -> String {
        return "Maciej"
    }
}
