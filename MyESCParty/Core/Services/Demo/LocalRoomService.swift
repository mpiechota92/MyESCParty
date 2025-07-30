//
//  LocalRoomService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

class LocalRoomService: RoomServiceProtocol, Cachable {
    var cacheTimestamp: Date?
    
    @Published private var usersCache: [RoomParticipant] = []
    
    var usersCachePublisher: Published<[RoomParticipant]>.Publisher {
        $usersCache
    }
    
    func leaveRoom(roomId: Int) async throws {
        
    }
    
    func deleteRoom(roomId: Int) async throws {
        
    }
}
