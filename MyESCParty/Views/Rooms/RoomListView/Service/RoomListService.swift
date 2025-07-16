//
//  RoomService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import Foundation
import Combine

enum RoomListServiceError: LocalizedError {
    case invalidPassword
    case roomNotFound
    case hashSaltMissing
    case passwordMissing
    case noPasswordProvided
    
    var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return "Invalid password."
        case .roomNotFound:
            return "We couldn’t process your request due to an internal error."
        case .hashSaltMissing:
            return "We couldn’t process your request due to an internal error."
        case .passwordMissing:
            return "We couldn’t process your request due to an internal error."
        case .noPasswordProvided:
            return "Password is required to join a private room."
        }
    }
}

protocol RoomListServiceProtocol {
    func fetchRooms(forceRefresh: Bool) async throws
    func joinRoom(id: Int, password: String?) async throws
    func isUserInRoom(id: Int) -> Bool
    func getRoom(id: Int) -> Room?
    func addUserToRoom(id: Int, isAdmin: Bool) async throws
    
    var roomListCachePublisher: Published<[Room]>.Publisher { get }
}

extension RoomListServiceProtocol {
    func fetchRooms(forceRefresh: Bool = false) async throws {
        try await fetchRooms(forceRefresh: forceRefresh)
    }
    
    func addUserToRoom(id: Int, isAdmin: Bool = false) async throws {
        try await addUserToRoom(id: id, isAdmin: isAdmin)
    }
    
    func joinRoom(id: Int, password: String? = nil) async throws {
        try await joinRoom(id: id, password: password)
    }
}

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Fetching rooms...")
        }
        #endif
        
        let rooms: [Room] = try await DatabaseManager.shared.client
            .from(.votingRoomsWithUserCount)
            .select()
            .execute()
            .value
        
        let userId = AuthManager.shared.getUserId() ?? ""
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
        guard let userId = AuthManager.shared.getUserId() else { return }
        
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
