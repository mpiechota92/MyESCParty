//
//  Contestant.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import Foundation

struct ContestGroup: OptionSet, Codable {
    let rawValue: Int
    
    static let firstSemi = ContestGroup(rawValue: 1 << 0)  // 1
    static let secondSemi = ContestGroup(rawValue: 1 << 1) // 2
    static let grandFinal = ContestGroup(rawValue: 1 << 2) // 4
}

struct Contestant: Codable, Identifiable {
    let id: Int
    let country: String
    let artist: String?
    let song: String?
    let songUrl: String?
    let imageUrl: String?
    let groups: ContestGroup
    
    enum CodingKeys: String, CodingKey {
        case id
        case country
        case artist
        case song
        case songUrl = "yt_url"
        case imageUrl = "image_url"
        case groups = "contest_group"
    }
}
