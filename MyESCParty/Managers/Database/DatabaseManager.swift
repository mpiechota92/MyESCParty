//
//  DatabaseManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import Foundation
import Supabase

class DatabaseManager {
    private let supabaseKey = "REMOVED"
    
    public static let shared = DatabaseManager()
    public var client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(supabaseURL: URL(string: "REMOVED")!, supabaseKey: supabaseKey)
    }
    
}

enum DBTable: String {
    case votingRoom = "voting_rooms"
    case votes = "votes"
    case votesPerRoom = "votes_per_room"
    case contests = "contests"
    case contestants = "contestants"
    case userVotingRooms = "user_voting_rooms"
    case roomUserCount = "room_user_count"
    case votingRoomsWithUserCount = "voting_rooms_with_user_count"
}
