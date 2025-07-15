//
//  RoomCreationViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/07/2025.
//

import Foundation

enum RoomCreationError: Error {
    
}

class RoomCreationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    private var roomCreationService: RoomCreationServiceProtocol
    private var roomService: RoomListServiceProtocol
    
    init(roomCreationService: RoomCreationServiceProtocol = RoomCreationService(),
         roomService: RoomListServiceProtocol = RoomListService()) {
        self.roomCreationService = roomCreationService
        self.roomService = roomService
    }
    
    @MainActor
    func createRoom(name: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let roomId = try await roomCreationService.createRoom(name: name, password: password)
            try await roomService.fetchRooms(forceRefresh: true)
            try await roomService.addUserToRoom(id: roomId, isAdmin: true)
        } catch {
            self.error = error
        }
    }
}
