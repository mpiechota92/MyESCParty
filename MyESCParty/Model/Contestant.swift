//
//  Contestant.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import Foundation

struct Contestant: Codable, Identifiable {
    let id: Int
    let country: Country
    let artist: String
    let song: String
    let songUrl: String
}
