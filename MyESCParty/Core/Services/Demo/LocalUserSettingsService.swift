//
//  LocalUserSettingsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import UIKit

class LocalUserSettingsService: UserSettingsServiceProtocol {
    func changeName(newName: String, for userID: String?) async throws -> Profile {
        return Profile(id: "123", username: "Maciej", avatarVersion: 0)
    }
    
    func uploadProfilePicture(imageJpegData: Data, for profile: Profile?) async throws {
        
    }
    
    func getUserData(for userID: String?) async throws -> Profile {
        return Profile(id: "123", username: "Maciej", avatarVersion: 0)
    }
    
    func getProfilePicture(for userID: String?) async throws -> UIImage? {
        return UIImage(named: "cat")!
    }
}
