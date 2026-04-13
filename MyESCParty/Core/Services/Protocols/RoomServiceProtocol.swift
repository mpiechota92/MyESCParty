//
//  RoomServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

protocol RoomServiceProtocol {
    typealias RoomID = Int
    
    func fetchUsers(roomId: Int, forceRefresh: Bool) async throws
    func leaveRoom(roomId: Int) async throws
    func deleteRoom(roomId: Int) async throws
    
    var usersCachePublisher: Published<[RoomID: [RoomParticipant]]>.Publisher { get }
}

extension RoomServiceProtocol {
    func fetchUsers(roomId: Int, forceRefresh: Bool = false) async throws {
        try await fetchUsers(roomId: roomId, forceRefresh: forceRefresh)
    }
}
