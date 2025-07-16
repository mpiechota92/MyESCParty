//
//  RoomViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import Foundation

class RoomViewModel: ObservableObject {
    private let service: RoomServiceProtocol
    private let roomId: Int
    
    @Published var userCount: Int = 0
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var users: [RoomParticipant] = []
    @Published var isAdmin: Bool = false
    
    init(service: RoomServiceProtocol = RoomService(), roomId: Int) {
        self.service = service
        self.roomId = roomId
        
        service.usersCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$users)
    }
    
    @MainActor
    func fetchUsers(forceRefresh: Bool = false) async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await service.fetchUsers(roomId: roomId, forceRefresh: forceRefresh)
            
            guard let userId = AuthManager.shared.getUserId() else {
                return
            }
            
            let user = users.first { $0.id == userId }
            
            if let isAdmin = user?.isAdmin {
                self.isAdmin = isAdmin
            }
        } catch {
            self.error = error
        }
    }
    
    func isUserAdmin() -> Bool {
        guard let userId = AuthManager.shared.getUserId() else {
            return false
        }
        
        let user = users.first { $0.id == userId }
        
        if let isAdmin = user?.isAdmin {
            return isAdmin
        }
        
        return false
    }
}
