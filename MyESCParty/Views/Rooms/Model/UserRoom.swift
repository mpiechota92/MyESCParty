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

#if DEBUG
extension UserRoom {
    static let adminMock: UserRoom = UserRoom(id: 1, isAdmin: true)
    static let mock: UserRoom = UserRoom(id: 2, isAdmin: false)
}
#endif
