//
//  LocalRoomCreationService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

class LocalRoomCreationService: RoomCreationService {
    override func createRoom(name: String, password: String) async throws -> Int {
        return 1
    }
}
