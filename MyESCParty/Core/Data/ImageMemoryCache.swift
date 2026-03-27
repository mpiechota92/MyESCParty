//
//  ImageMemoryCache.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 27/03/2026.
//

import Foundation

final class ImageMemoryCache {
    private let cache = NSCache<NSString, NSData>()
    
    func get(for imageUrl: String) -> Data? {
        cache.object(forKey: NSString(string: imageUrl)) as Data?
    }
    
    func set(_ data: Data, for imageUrl: String) {
        cache.setObject(NSData(data: data), forKey: NSString(string: imageUrl))
    }
}
