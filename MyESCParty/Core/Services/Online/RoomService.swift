//
//  RoomService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/07/2025.
//

import Foundation

class RoomService: RoomServiceProtocol, Cachable {
    var cacheTimestamp: Date?
    
    @Published private var usersCache: [RoomID: [RoomParticipant]] = [:]
    private var cacheTimestamps: [RoomID: Date] = [:]
    
    var usersCachePublisher: Published<[RoomID: [RoomParticipant]]>.Publisher {
        $usersCache
    }
    
    func fetchUsers(roomId: Int, forceRefresh: Bool = false) async throws {
        let now = Date()
        
        if !forceRefresh, let timestamp = cacheTimestamps[roomId], now.timeIntervalSince(timestamp) < cacheTTL {
            return
        }
        
        #if DEBUG
        print("Fetching users in room \(roomId)...")
        #endif
        
        let users: [RoomParticipant] = try await DatabaseManager.shared.client
            .from(.usersInVotingRooms)
            .select()
            .eq(RoomParticipant.CodingKeys.roomId.rawValue, value: roomId)
            .execute()
            .value
        
        cacheTimestamps[roomId] = now
        usersCache[roomId] = users
    }
    
    func leaveRoom(roomId: Int) async throws {
        guard let userId = AuthManager.shared.getUserUUID() else {
            return
        }
        
        #if DEBUG
        print("Leaving room: \(roomId) by user: \(userId)...")
        #endif
        
        try await DatabaseManager.shared.client
            .from(.userVotingRooms)
            .delete()
            .eq("user_id", value: userId.uuidString)
            .execute()
    }
    
    func deleteRoom(roomId: Int) async throws {
        try await DatabaseManager.shared.client
            .from(.votingRoom)
            .delete()
            .eq(Room.CodingKeys.id.rawValue, value: String(roomId))
            .execute()
    }
}
