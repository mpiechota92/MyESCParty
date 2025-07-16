//
//  RoomService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/07/2025.
//

import Foundation

protocol RoomServiceProtocol {
    func fetchUsers(roomId: Int, forceRefresh: Bool) async throws
    
    var usersCachePublisher: Published<[RoomParticipant]>.Publisher { get }
}

extension RoomServiceProtocol {
    func fetchUsers(roomId: Int, forceRefresh: Bool = false) async throws {
        try await fetchUsers(roomId: roomId, forceRefresh: forceRefresh)
    }
}

class RoomService: RoomServiceProtocol, Cachable {
    var cacheTimestamp: Date?
    
    @Published private var usersCache: [RoomParticipant] = []
    
    var usersCachePublisher: Published<[RoomParticipant]>.Publisher {
        $usersCache
    }
    
    func fetchUsers(roomId: Int, forceRefresh: Bool = false) async throws {
        let now = Date()
        
        if !forceRefresh, let timestamp = cacheTimestamp, now.timeIntervalSince(timestamp) < cacheTTL {
            return
        }
        
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Fetching users in room \(roomId)...")
        }
        #endif
        
        let users: [RoomParticipant] = try await DatabaseManager.shared.client
            .from(.usersInVotingRooms)
            .select()
            .eq(RoomParticipant.CodingKeys.roomId.rawValue, value: roomId)
            .execute()
            .value
        
        cacheTimestamp = now
        usersCache = users
    }
}
