//
//  RoomService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import Foundation
import Combine

enum RoomType {
    case publicRoom
    case privateRoom
}

enum RoomServiceError: Error {
    case invalidPassword
    case roomNotFound
    case hashSaltMissing
    case passwordMissing
    case noPasswordProvided
}

protocol RoomServiceProtocol {
    func fetchRooms(forceRefresh: Bool) async throws
    func joinRoom(id: Int, password: String?) async throws
    func createRoom(name: String, type: RoomType) async throws
    func getRoomType(id: Int) async throws -> RoomType
    func joinRoomWithPassword(id: Int, password: String) async throws
    func isUserInRoom(id: Int) async throws -> Bool
}

class RoomService: RoomServiceProtocol, Cachable {
    @Published private(set) var roomCache: [Room] = []
    private(set) var userRoomsCache: [UserRoom] = []
    
    var cacheTimestamp: Date? =  nil
    
    
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
            .from(.votinRoomsWithUserCount)
            .select()
            .execute()
            .value
        
        let userId = AuthManager.shared.getUserId() ?? ""
        let userRooms: [UserRoom] = try await DatabaseManager.shared.client
            .from(.userVotingRooms)
            .select("room_id")
            .eq("user_id", value: userId)
            .execute()
            .value
        
        cacheTimestamp = now
        roomCache = rooms
        userRoomsCache = userRooms
    }
    
    private func addUserToRoom(id: Int) async throws {
        guard let userId = AuthManager.shared.getUserId() else { return }
        
        let _ = try await DatabaseManager.shared.client
            .from(.userVotingRooms)
            .insert(["user_id": userId, "room_id": String(id)])
            .select()
            .execute()
        
    }
    
    func joinRoomWithPassword(id: Int, password: String) async throws {
        
    }
    
    func createRoom(name: String, type: RoomType = .publicRoom) async throws {
        
    }
    
    func joinRoom(id: Int, password: String? = nil) async throws {
        let type = try await getRoomType(id: id)
        
        switch type {
        case .publicRoom:
            try await addUserToRoom(id: id)
        case .privateRoom:
            guard let password, !password.isEmpty else {
                print("No password provided")
                throw RoomServiceError.noPasswordProvided
            }
            
            let room = try await getRoom(id: id)
            
            guard let room else {
                print("Room not found")
                throw RoomServiceError.roomNotFound
            }
            
            guard let salt = room.salt else {
                print("Room has no salt")
                throw RoomServiceError.hashSaltMissing
            }
            
            guard let roomHash = room.passwordHash else {
                print("Room has no password")
                throw RoomServiceError.passwordMissing
            }
            
            let hashedPassword = Security.hashPassword(password, salt: salt)
            
            if hashedPassword != roomHash {
                print("Passwords don't match")
                throw RoomServiceError.invalidPassword
            }
            
            try await addUserToRoom(id: id)
        }
    }
    
    func getRoomType(id: Int) async throws -> RoomType {
        let room = try await getRoom(id: id)
        
        if let room, room.passwordHash != nil {
            return .privateRoom
        }
        
        return .publicRoom
    }
    
    func getRoom(id: Int) async throws -> Room? {
        try await fetchRooms()
        return roomCache.first(where: { $0.id == id })
    }
    
    func isUserInRoom(id: Int) -> Bool {
        if let _ = userRoomsCache.first(where: { $0.id == id }) {
            return true
        }
        
        return false
    }
    
}
