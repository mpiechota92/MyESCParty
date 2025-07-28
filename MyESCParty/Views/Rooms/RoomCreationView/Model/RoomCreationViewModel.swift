//
//  RoomCreationViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/07/2025.
//

import Foundation

enum RoomCreationError: Error {
    
}

class RoomCreationViewModel: BaseViewModel {
    private var roomCreationService: RoomCreationServiceProtocol
    private var roomService: RoomListServiceProtocol
    
    init(roomCreationService: RoomCreationServiceProtocol = RoomCreationService(),
         roomService: RoomListServiceProtocol = RoomListService()) {
        self.roomCreationService = roomCreationService
        self.roomService = roomService
    }
    
    @MainActor
    func createRoom(name: String, password: String) async {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            let roomId = try await self.roomCreationService.createRoom(name: name, password: password)
            try await self.roomService.fetchRooms(forceRefresh: true)
            try await self.roomService.addUserToRoom(id: roomId, isAdmin: true)
        }
    }
}
