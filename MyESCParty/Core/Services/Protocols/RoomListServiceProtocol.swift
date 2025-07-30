//
//  RoomListServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

enum RoomListServiceError: LocalizedError {
    case invalidPassword
    case roomNotFound
    case hashSaltMissing
    case passwordMissing
    case noPasswordProvided
    
    var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return "Invalid password."
        case .roomNotFound:
            return "We couldn’t process your request due to an internal error."
        case .hashSaltMissing:
            return "We couldn’t process your request due to an internal error."
        case .passwordMissing:
            return "We couldn’t process your request due to an internal error."
        case .noPasswordProvided:
            return "Password is required to join a private room."
        }
    }
}

protocol RoomListServiceProtocol {
    func fetchRooms(forceRefresh: Bool) async throws
    func joinRoom(id: Int, password: String?) async throws
    func isUserInRoom(id: Int) -> Bool
    func getRoom(id: Int) -> Room?
    func addUserToRoom(id: Int, isAdmin: Bool) async throws
    
    var roomListCachePublisher: Published<[Room]>.Publisher { get }
}

extension RoomListServiceProtocol {
    func fetchRooms(forceRefresh: Bool = false) async throws {
        try await fetchRooms(forceRefresh: forceRefresh)
    }
    
    func addUserToRoom(id: Int, isAdmin: Bool = false) async throws {
        try await addUserToRoom(id: id, isAdmin: isAdmin)
    }
    
    func joinRoom(id: Int, password: String? = nil) async throws {
        try await joinRoom(id: id, password: password)
    }
}
