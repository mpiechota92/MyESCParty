//
//  RoomViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import Foundation

class RoomViewModel: ObservableObject {
    private let service: RoomListServiceProtocol
    
    @Published var userCount: Int = 0
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    init(service: RoomListServiceProtocol = RoomListService(), roomId: Int) {
        self.service = service
        
        service.roomCachePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { rooms in
                let room = rooms.first { $0.id == roomId }
                return room?.userCount
            }
            .assign(to: &$userCount)
    }
    
    @MainActor
    func fetchUserCount() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await service.fetchRooms()
        } catch {
            self.error = error
        }
    }
}
