//
//  UserRoom.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import Foundation

struct UserRoom: Decodable {
    let id: Int
    let isAdmin: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
        case isAdmin = "is_admin"
    }
}
