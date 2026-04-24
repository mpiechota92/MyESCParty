//
//  UserSettingsViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import Storage
import UIKit

enum ProfilePictureState {
    case none
    case loading
    case failedLoading
    case loaded(UIImage)
}

@MainActor
class UserSettingsViewModel: BaseViewModel {
    private let service: UserSettingsServiceProtocol
    
    @Published var userProfile: Profile?
    @Published var userProfileImage: UIImage?
    @Published var isProfilePictureLoading: Bool = false
    @Published var profilePictureState: ProfilePictureState = .none
    
    private let userID: String?
    
    init(service: UserSettingsServiceProtocol = UserSettingsService(), userID: String?) {
        self.service = service
        self.userID = userID
        super.init()
    }
    
    func changeName(newName: String) async throws {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            self.userProfile = try await self.service.changeName(newName: newName, for: userID)
        }
    }
    
    func changePicture(newPicture: Data) async throws {
        profilePictureState = .loading
        await performWithLoading(type: .none) { [weak self] in
            guard let self = self else { return }
            do {
                self.userProfile = try await self.service.uploadProfilePicture(imageJpegData: newPicture, for: userProfile)
                
                if let image = UIImage(data: newPicture) {
                    self.profilePictureState = .loaded(image)
                } else {
                    self.profilePictureState = .failedLoading
                }
            } catch {
                self.profilePictureState = .failedLoading
                throw error
            }
        }
    }
    
    func fetchUserData() async throws {
        profilePictureState = .loading
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            self.userProfile = try await self.fetchUserProfile()
            
            do {
                if let image = try await self.fetchProfilePicture() {
                    self.userProfileImage = image
                    self.profilePictureState = .loaded(image)
                } else {
                    self.profilePictureState = .none
                }
            } catch let error as StorageError {
                if error.statusCode == "404" || error.error == "not_found" {
                    self.profilePictureState = .none
                } else {
                    throw error
                }
            } catch {
                self.profilePictureState = .failedLoading
                throw error
            }
        }
    }
    
    private func fetchUserProfile() async throws -> Profile {
        try await self.service.getUserData(for: userID)
    }
    
    private func fetchProfilePicture() async throws -> UIImage? {
        try await self.service.getProfilePicture(for: userID)
    }
}

struct SelectedAvatarImage: Identifiable, Hashable {
    let id = UUID()
    let image: UIImage
}
