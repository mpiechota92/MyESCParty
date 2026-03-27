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
    func fetchRooms(forceRefresh: Bool = false, loadingType: LoadingType = .scrollView) async {
        await performWithLoading(type: loadingType) { [weak self] in
            guard let self = self else { return }
            try await self.service.fetchRooms(forceRefresh: forceRefresh)
        }
    }
    
    func joinRoom(id: Int, password: String? = nil) async {
        do {
            
            //TODO: Make a fetchRoom method to fetch specific data about single room
            // The fetch here is to update the data about the room such as:
            // - people in the room
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
                    // Should not occur
                    throw RoomListServiceError.passwordMissing
                }
                
                let hashedPassword = SecurityHelper.hashPassword(password, salt: salt)
                
                if hashedPassword != roomHash {
                    throw RoomListServiceError.invalidPassword
                }
                
                try await service.addUserToRoom(id: id)
            }
            
            // TODO: does it have to be called here when it only fetches the rooms?
            try await service.joinRoom(id: id, password: password)
        } catch {
            self.error = error
        }
    }
    
    func isUserInRoom(_ id: Int) -> Bool {
        service.isUserInRoom(id: id)
    }
}
