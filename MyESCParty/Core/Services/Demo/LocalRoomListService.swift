//
//  LocalRoomListService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

class LocalRoomListService: RoomListServiceProtocol, Cachable {
    @Published private(set) var roomCache: [Room] = []
    private(set) var userRoomsCache: [UserRoom] = []
    
    var cacheTimestamp: Date? =  nil
    
    var roomListCachePublisher: Published<[Room]>.Publisher {
        $roomCache
    }
    
    func fetchRooms(forceRefresh: Bool) async throws {
        let rooms: [Room]? = try DemoDataReader.getDataForTable(table: .votingRoomsWithUserCount)
        let userRooms: [UserRoom]? = try DemoDataReader.getDataForTable(table: .userVotingRooms)
        
        guard let rooms, let userRooms else {
            throw DemoDataReaderError.couldNotRead
        }
        
        roomCache = rooms
        userRoomsCache = userRooms
    }
    
    func addUserToRoom(id: Int, isAdmin: Bool) async throws {
        
    }
    
    func joinRoom(id: Int, password: String?) async throws {
        
    }
}
