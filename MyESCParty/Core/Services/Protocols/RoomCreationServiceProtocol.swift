//
//  RoomCreationServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

protocol RoomCreationServiceProtocol {
    func createRoom(name: String, password: String) async throws -> Int
}
