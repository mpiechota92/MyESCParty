//
//  UserSettingsViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import Foundation

class UserSettingsViewModel: BaseViewModel {
    private let service: UserSettingsServiceProtocol
    
    @Published var userName: String = ""
    
    private let userID: String?
    
    init(service: UserSettingsServiceProtocol = UserSettingsService(), userID: String?) {
        self.service = service
        self.userID = userID
        super.init()
    }
    
    func changeName(newName: String) async throws {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            let updatedProfile = try await self.service.changeName(newName: newName, for: userID)
            self.userName = updatedProfile.username
        }
    }
    
    func changePicture(newPicture: Data) async throws {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            try await self.service.changeProfilePicture(newProfilePicture: newPicture)
        }
    }
    
    func fetchUser(userId id: String?) async throws {
        guard let id else {
            throw NSError(domain: "No user id", code: 0, userInfo: nil)
        }
        
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            self.userName = try await self.service.getUserData(userId: id)
        }
    }
}
