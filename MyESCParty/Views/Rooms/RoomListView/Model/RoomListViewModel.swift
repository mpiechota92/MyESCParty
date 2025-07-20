//
//  RoomListViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import Foundation

class RoomListViewModel: BaseViewModel {
    
    private let service: RoomListServiceProtocol
    
    @Published var rooms: [Room] = []
    @Published var searchText: String = ""
    
    init(service: RoomListServiceProtocol = RoomListService()) {
        self.service = service
        super.init()
        
        self.service.roomListCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$rooms)
    }
    
    @MainActor
    func fetchRooms() async {
        performWithLoading(type: .inline) { [weak self] in
            guard let self = self else { return }
            try await self.service.fetchRooms(forceRefresh: true)
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
