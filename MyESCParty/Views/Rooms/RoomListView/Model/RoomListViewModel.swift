//
//  RoomListViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import Foundation

class RoomListViewModel: ObservableObject {
    
    private let service: RoomListServiceProtocol
    
    @Published var rooms: [Room] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var error: Error?
    
    init(service: RoomListServiceProtocol = RoomListService()) {
        self.service = service
        
        service.roomCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$rooms)
    }
    
    @MainActor
    func fetchRooms() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await service.fetchRooms(forceRefresh: true)
        } catch {
            print(error)
        }
    }
    
    func joinRoom(id: Int, password: String? = nil) async {
        do {
            try await service.fetchRooms(forceRefresh: true)
            
            guard let room = service.getRoom(id: id) else {
                throw RoomListServiceError.roomNotFound
            }
            
            let type: RoomType = room.passwordHash == nil ? .publicRoom : .privateRoom
            
            switch type {
            case .publicRoom:
                try await service.addUserToRoom(id: id)
            case .privateRoom:
                guard let password, !password.isEmpty else {
                    throw RoomListServiceError.noPasswordProvided
                }
                
                guard let salt = room.salt else {
                    throw RoomListServiceError.hashSaltMissing
                }
                
                guard let roomHash = room.passwordHash else {
                    throw RoomListServiceError.passwordMissing
                }
                
                let hashedPassword = SecurityHelper.hashPassword(password, salt: salt)
                
                if hashedPassword != roomHash {
                    throw RoomListServiceError.invalidPassword
                }
                
                try await service.addUserToRoom(id: id)
            }
            
            try await service.joinRoom(id: id, password: password)
        } catch {
            self.error = error
        }
    }
    
    func isUserInRoom(_ id: Int) -> Bool {
        service.isUserInRoom(id: id)
    }
}
