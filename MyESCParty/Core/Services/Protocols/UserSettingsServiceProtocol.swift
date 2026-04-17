//
//  UserSettingsServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import Foundation

protocol UserSettingsServiceProtocol {
    func changeName(newName: String, for userID: String?) async throws  -> Profile
    func changeProfilePicture(newProfilePicture: Data) async throws
    func getUserData(userId id: String) async throws -> String
}
