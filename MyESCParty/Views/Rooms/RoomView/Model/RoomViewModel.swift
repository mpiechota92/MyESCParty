//
//  RoomViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import Foundation

class RoomViewModel: BaseViewModel {
    private let service: RoomServiceProtocol
    let roomId: Int
    
    @Published var userCount: Int = 0
    @Published var users: [RoomParticipant] = []
    @Published var isAdmin: Bool = false
    
    init(service: RoomServiceProtocol = RoomService(), roomId: Int) {
        self.service = service
        self.roomId = roomId
        super.init()
        
        service.usersCachePublisher
            .map { $0[roomId] ?? [] }
            .receive(on: DispatchQueue.main)
            .assign(to: &$users)
    }
    
    @MainActor
    func fetchUsers(forceRefresh: Bool = false) async {
        await performWithLoading(type: .inline) { [weak self] in
            guard let self = self else { return }
            
            try await self.service.fetchUsers(roomId: self.roomId, forceRefresh: forceRefresh)
            
            guard let userId = AuthManager.shared.getUserUUID() else {
                return
            }
            
            let user = self.users.first { $0.id == userId }
            
            if let isAdmin = user?.isAdmin {
                self.isAdmin = isAdmin
            }
        }
    }
    
    @MainActor
    func leaveRoom() async {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            try await self.service.leaveRoom(roomId: self.roomId)
        }
    }
    
    @MainActor
    func deleteRoom() async {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            try await self.service.deleteRoom(roomId: self.roomId)
        }
    }
}
