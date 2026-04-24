//
//  DatabaseManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import Foundation
import Supabase

struct SupabaseAPI: Decodable {
    let url: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case url = "SUPABASE_URL"
        case key = "SUPABASE_ANON_KEY"
    }
}

class DatabaseManager {
    public static let shared = DatabaseManager()
    public var client: SupabaseClient
    
    private init() {
        let supabaseAPI: SupabaseAPI = Bundle.main.decode("Supabase")
        self.client = SupabaseClient(supabaseURL: URL(string: supabaseAPI.url)!, supabaseKey: supabaseAPI.key)
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
    case profiles = "profiles"
    case usersInVotingRooms = "users_in_voting_rooms"
}

enum DBStorageBucket: String {
    case profilePictures = "pfp"
}

enum DBFunction: String {
    case updateProfilePictureVersion = "update_profile_picture_version"
}
