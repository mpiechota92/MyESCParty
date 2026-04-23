//
//  AppUser.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import Foundation

struct AppUser {
    let uid: String
    let email: String?
    let username: String
    
    init(uid: String, email: String?, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
    }
}

struct Profile: Codable {
    let id: String
    var username: String
    var avatarVersion: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case avatarVersion = "avatar_version"
    }
}

extension AppUser {
    static let mock: AppUser = AppUser(uid: "123", email: "email@mock.com", username: "Maciej")
}
