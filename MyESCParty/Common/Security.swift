//
//  Security.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 07/07/2025.
//

import Foundation
import CryptoKit

struct Security {
    static func hashPassword(_ password: String, salt: String) -> String {
        let salted = password + salt
        let hash = SHA256.hash(data: Data(salted.utf8))
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
