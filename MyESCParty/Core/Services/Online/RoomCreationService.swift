//
//  RoomCreationService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/07/2025.
//

import Foundation
import Supabase

class RoomCreationService: RoomCreationServiceProtocol {
    func createRoom(name: String, password: String) async throws -> Int {
        let roomUUID = UUID()
        let salt = UUID().uuidString
        let passwordHash = SecurityHelper.hashPassword(password, salt: salt)
        
        let insertData: [String: String?] = [
            Room.CodingKeys.name.rawValue: name,
            Room.CodingKeys.salt.rawValue: password.isEmpty ? nil : salt,
            Room.CodingKeys.passwordHash.rawValue: password.isEmpty ? nil : passwordHash,
            Room.CodingKeys.uuid.rawValue: roomUUID.uuidString,
        ]
        
        let room: Room = try await DatabaseManager.shared.client
            .from(.votingRoom)
            .insert(insertData)
            .select()
            .single()
            .execute()
            .value
        
        return room.id
    }
}
