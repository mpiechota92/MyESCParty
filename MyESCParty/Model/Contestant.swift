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

extension Contestant {
    static let mock: Contestant = Contestant(
        id: 1,
        country: "Sweden",
        artist: "Loreen",
        song: "Tattoo",
        songUrl: "https://www.youtube.com/watch?v=BE2Fj0W4jP4",
        imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Loreen_-_Melodifestivalen_2023%2C_Malm%C3%B6_118_%28cropped%29.jpg/330px-Loreen_-_Melodifestivalen_2023%2C_Malm%C3%B6_118_%28cropped%29.jpg",
        groups: [.firstSemi, .grandFinal]
    )
}
