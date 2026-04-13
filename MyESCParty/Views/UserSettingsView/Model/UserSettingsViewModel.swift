//
//  UserSettingsViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import Foundation

class UserSettingsViewModel: BaseViewModel {
    private let service: UserSettingsServiceProtocol
    
    var userName: String = ""
    
    init(service: UserSettingsServiceProtocol = UserSettingsService()) {
        self.service = service
        super.init()
    }
    
    func changeName(newName: String) async throws {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { }
            //try await self.service.changeName(newName: newName)
        }
    }
    
    func changePicture(newPicture: Data) async throws {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            try await self.service.changeProfilePicture(newProfilePicture: newPicture)
        }
    }
    
    func getUser(userId id: String?) async throws {
        guard let id else {
            throw NSError(domain: "No user id", code: 0, userInfo: nil)
        }
        
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            self.userName = try await self.service.getUserData(userId: id)
        }
    }
}
