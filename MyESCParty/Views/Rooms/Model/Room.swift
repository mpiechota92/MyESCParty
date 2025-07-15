//
//  Room.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import Foundation

struct Room: Identifiable, Decodable {
    let id: Int
    let name: String
    let passwordHash: String?
    let salt: String?
    let userCount: Int?
    let uuid: UUID?
    
    var roomType: RoomType {
        if let hash = passwordHash, !hash.isEmpty {
            return .privateRoom
        }
        
        return .publicRoom
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
        case name = "room_name"
        case passwordHash = "password_hash"
        case salt
        case userCount = "user_count"
        case uuid = "room_uuid"
    }
}
