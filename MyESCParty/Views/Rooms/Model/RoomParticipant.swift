//
//  RoomParticipant.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/07/2025.
//

import Foundation

struct RoomParticipant: Identifiable, Decodable {
    var id: UUID
    var roomId: Int
    var username: String
    var isAdmin: Bool?
    
    // TODO: Add version of the image so if it's updated,
    // the new one is downloaded right away
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case roomId = "room_id"
        case username
        case isAdmin = "is_admin"
    }
}

#if DEBUG
extension RoomParticipant {
    static let room1AdminMock: RoomParticipant = RoomParticipant(id: UUID(), roomId: 2, username: "Admin User", isAdmin: true)
    static let room1UserMock: RoomParticipant = RoomParticipant(id: UUID(), roomId: 2, username: "Normal User", isAdmin: nil)
    static let room2UserMock: RoomParticipant = RoomParticipant(id: UUID(), roomId: 1, username: "Normal User 2", isAdmin: nil)
}
#endif
