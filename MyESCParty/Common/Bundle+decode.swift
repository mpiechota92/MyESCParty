//
//  Bundle+decode.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: "plist") else {
            fatalError("Coudn't find \(file).plist in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Couldn't load \(file).plist")
        }
        
        let decoder = PropertyListDecoder()
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Coudn't decode \(file).plist")
        }
        
        return decoded
    }
}
