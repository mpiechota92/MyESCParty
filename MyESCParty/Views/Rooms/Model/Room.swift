//
//  Room.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import Foundation

struct Room: Identifiable, Decodable, Hashable {
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

extension Room {
    static let publicRoomId: Int = 3
}

#if DEBUG
extension Room {
    static let publicRoomMock: Room = Room(
        id: 1,
        name: "Public room",
        passwordHash: nil,
        salt: nil,
        userCount: 2,
        uuid: UUID()
    )
    
    // password: testpassword
    static let privateRoomMock: Room = Room(
        id: 2,
        name: "Private room",
        passwordHash: "b2e76d91fd61a39e1dc84bba1bbf8fc7efb7b30311b2b6a3b35cc3753f1be201",
        salt: "c7e82a43-2bcd-470f-9ba7-3d8ea758eafe",
        userCount: 2,
        uuid: UUID()
    )
}
#endif
