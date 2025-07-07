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
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}
