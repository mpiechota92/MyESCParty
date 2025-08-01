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
    
    func fetchUsers(roomId: Int, forceRefresh: Bool) async throws {
        guard let users: [RoomParticipant] = try DemoDataReader.getDataForTable(table: .usersInVotingRooms) else {
            throw DemoDataReaderError.couldNotRead
        }
        
        let filteredUsers = users.filter { $0.roomId == roomId }
        usersCache = filteredUsers
    }
    
    func leaveRoom(roomId: Int) async throws {
        
    }
    
    func deleteRoom(roomId: Int) async throws {
        
    }
}
