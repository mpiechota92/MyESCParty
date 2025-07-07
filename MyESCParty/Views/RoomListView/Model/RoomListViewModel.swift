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
    let userCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
        case name = "room_name"
        case passwordHash = "password_hash"
        case salt
        case userCount = "user_count"
    }
}

struct UserRoom: Decodable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
    }
}

@MainActor
class RoomListViewModel: ObservableObject {
    
    private let service: RoomService
    
    @Published var rooms: [Room] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    init(service: RoomService = .init()) {
        self.service = service
        
        service.$roomCache
            .receive(on: DispatchQueue.main)
            .assign(to: &$rooms)
    }
    
    func fetchRooms() async {
        isLoading = true
        do {
            try await service.fetchRooms(forceRefresh: true)
            isLoading = false
        } catch {
            isLoading = false
            print(error)
        }
    }
    
    func joinRoom(id: Int, password: String? = nil) async {
        do {
            try await service.joinRoom(id: id, password: password)
        } catch {
            print(error)
        }
    }
    
    func isUserInRoom(_ id: Int) -> Bool {
        service.isUserInRoom(id: id)
    }
}
