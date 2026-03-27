//
//  RoomService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import Foundation

class RoomListService: RoomListServiceProtocol, Cachable {
    @Published private(set) var roomCache: [Room] = []
    private(set) var userRoomsCache: [UserRoom] = []
    
    var cacheTimestamp: Date? =  nil
    
    var roomListCachePublisher: Published<[Room]>.Publisher {
        $roomCache
    }
    
    func fetchRooms(forceRefresh: Bool = false) async throws {
        let now = Date()
        
        if !forceRefresh, let timestamp = cacheTimestamp, now.timeIntervalSince(timestamp) < cacheTTL {
            return
        }
        
        #if DEBUG
        print("Fetching rooms...")
        #endif
        
        let rooms: [Room] = try await DatabaseManager.shared.client
            .from(.votingRoomsWithUserCount)
            .select()
            .execute()
            .value
        
        let userId = AuthManager.shared.getUserUUID()?.uuidString ?? ""
        let userRooms: [UserRoom] = try await DatabaseManager.shared.client
            .from(.userVotingRooms)
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value
        
        cacheTimestamp = now
        roomCache = rooms
        userRoomsCache = userRooms
    }
    
    func addUserToRoom(id: Int, isAdmin: Bool = false) async throws {
        guard let userId = AuthManager.shared.getUserUUID()?.uuidString else { return }
        
        let insertData: [String: String] = [
            "user_id": userId,
            "room_id": String(id),
            "is_admin": String(isAdmin)
        ]
        
        try await DatabaseManager.shared.client
            .from(.userVotingRooms)
            .insert(insertData)
            .select()
            .execute()
    }
    
    // TODO: shouldn't call fetchRooms
    func joinRoom(id: Int, password: String? = nil) async throws {
        try await fetchRooms(forceRefresh: true)
        
    }
    
    func getRoom(id: Int) -> Room? {
        return roomCache.first(where: { $0.id == id })
    }
    
    func isUserInRoom(id: Int) -> Bool {
        userRoomsCache.contains { $0.id == id }
    }
    
}
