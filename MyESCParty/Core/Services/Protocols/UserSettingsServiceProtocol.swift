//
//  UserSettingsServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import UIKit

enum UserSettingsServiceError: Error, LocalizedError {
    case nameDuplicated
    case nameUpdateFailure
    case missingUserID
    case couldNotLoadUserData
    
    var errorDescription: String? {
        switch self {
        case .nameDuplicated:
            return "Name is already taken"
        case .nameUpdateFailure:
            return "Failed to update name"
        case .missingUserID:
            return "Missing user ID"
        case .couldNotLoadUserData:
            return "Could not load user data"
        }
    }
}

protocol UserSettingsServiceProtocol {
    func changeName(newName: String, for userID: String?) async throws  -> Profile
    func uploadProfilePicture(imageJpegData: Data, for profile: Profile?) async throws
    func getUserData(for userID: String?) async throws -> Profile
    func getProfilePicture(for userID: String?) async throws -> UIImage?
}
