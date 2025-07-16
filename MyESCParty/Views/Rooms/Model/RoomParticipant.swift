//
//  RoomParticipant.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/07/2025.
//

import Foundation

struct RoomParticipant: Identifiable, Decodable {
    var id: String
    var roomId: Int
    var username: String
    var isAdmin: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case roomId = "room_id"
        case username
        case isAdmin = "is_admin"
    }
}
