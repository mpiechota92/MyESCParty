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
    
    func isUserInRoom(id: Int) -> Bool {
        true
    }
    
    func getRoom(id: Int) -> Room? {
        nil
    }
    
}
