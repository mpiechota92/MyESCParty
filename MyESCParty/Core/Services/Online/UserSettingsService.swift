//
//  UserSettingsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import UIKit
import Storage

class UserSettingsService: UserSettingsServiceProtocol {
    private let databaseManager: DatabaseManager = DatabaseManager.shared
    private let imageCache: ImageCache = ImageCache.shared
    
    func changeName(
        newName: String,
        for userID: String?
    ) async throws -> Profile {
        guard let userID else {
            throw UserSettingsServiceError.missingUserID
        }
        
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
            .eq("id", value: userID)
            .select()
            .execute()
            .value
        
        guard let profile = updatedProfiles.first else {
            throw UserSettingsServiceError.nameUpdateFailure
        }
        
        return profile
    }
    
    func uploadProfilePicture(
        imageJpegData data: Data,
        for profile: Profile?
    ) async throws -> Profile {
        guard let profile else {
            throw UserSettingsServiceError.missingUserID
        }
        
        let fileOptions = FileOptions(
            cacheControl: "3600",
            contentType: "image/jpeg",
            upsert: true
        )
        
        let userID = profile.id.lowercased()
        
        try await databaseManager.client.storage
            .from(.profilePictures)
            .upload(
                "\(userID).jpeg",
                data: data,
                options: fileOptions
            )
        
        let updatedProfile: Profile = try await databaseManager.client
            .rpc(.updateProfilePictureVersion)
            .execute()
            .value
        
        imageCache.saveImage(data, fileName: userID)
        
        return updatedProfile
    }
    
    func getProfilePicture(for userID: String?) async throws -> UIImage? {
        guard let lowercasedUserID = userID?.lowercased() else {
            throw UserSettingsServiceError.missingUserID
        }
        
        if let cachedImageData = imageCache.image(for: lowercasedUserID) {
            if let image = UIImage(data: cachedImageData) {
                return image
            }
            
            throw UserSettingsServiceError.couldNotLoadProfilePicture
        }
        
        let imageData = try await databaseManager.client.storage
            .from(.profilePictures)
            .download(path: "\(lowercasedUserID).jpeg")
        
        imageCache.saveImage(imageData, fileName: lowercasedUserID)
        
        return UIImage(data: imageData)
    }
    
    func getUserData(for userID: String?) async throws -> Profile {
        guard let userID else {
            throw UserSettingsServiceError.missingUserID
        }
        
        let profiles: [Profile] = try await databaseManager.client
            .from(.profiles)
            .select()
            .eq("id", value: userID)
            .execute()
            .value
        
        guard let profile = profiles.first else {
            throw UserSettingsServiceError.couldNotLoadUserData
        }
        
        return profile
    }
}
