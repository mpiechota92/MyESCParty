//
//  RoomListViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import Foundation

struct Room: Identifiable, Decodable {
    let id: Int
    let name: String
    let passwordHash: String?
    let salt: String?
    let userCount: Int?
    let uuid: UUID?
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
        case name = "room_name"
        case passwordHash = "password_hash"
        case salt
        case userCount = "user_count"
        case uuid = "room_uuid"
    }
}

struct UserRoom: Decodable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
    }
}

class RoomListViewModel: ObservableObject {
    
    private let service: RoomServiceProtocol
    
    @Published var rooms: [Room] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var error: Error?
    
    init(service: RoomServiceProtocol = RoomService()) {
        self.service = service
        
        service.roomCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$rooms)
    }
    
    @MainActor
    func fetchRooms() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await service.fetchRooms(forceRefresh: true)
        } catch {
            print(error)
        }
    }
    
    func joinRoom(id: Int, password: String? = nil) async {
        do {
            try await service.fetchRooms(forceRefresh: true)
            
            guard let room = service.getRoom(id: id) else {
                throw RoomServiceError.roomNotFound
            }
            
            let type = room.passwordHash == nil ? RoomType.publicRoom : .privateRoom
            
            switch type {
            case .publicRoom:
                try await service.addUserToRoom(id: id)
            case .privateRoom:
                guard let password, !password.isEmpty else {
                    throw RoomServiceError.noPasswordProvided
                }
                
                guard let salt = room.salt else {
                    throw RoomServiceError.hashSaltMissing
                }
                
                guard let roomHash = room.passwordHash else {
                    throw RoomServiceError.passwordMissing
                }
                
                let hashedPassword = SecurityHelper.hashPassword(password, salt: salt)
                
                if hashedPassword != roomHash {
                    throw RoomServiceError.invalidPassword
                }
                
                try await service.addUserToRoom(id: id)
            }
            
            try await service.joinRoom(id: id, password: password)
        } catch {
            self.error = error
        }
    }
    
    func isUserInRoom(_ id: Int) -> Bool {
        service.isUserInRoom(id: id)
    }
}
