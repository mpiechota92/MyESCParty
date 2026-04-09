//
//  ImageCache.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 02/04/2026.
//

import Foundation
import CryptoKit

final class ImageCache {
    static let shared = ImageCache()
    
    private let memory = ImageMemoryCache()
    private let disk = ImageDiskCache()
    
    func image(for imageUrl: String) -> Data? {
        let memoryData = memory.get(for: imageUrl)
        if let memoryData {
            return memoryData
        }
        
        let diskData = disk.load(for: cacheKey(for: imageUrl))
        if let diskData {
            memory.set(diskData, for: imageUrl)
            return diskData
        }
        
        return nil
    }
    
    func saveImage(_ data: Data, fileName url: String) {
        memory.set(data, for: url)
        disk.save(data, for: cacheKey(for: url))
    }
    
    private func cacheKey(for url: String) -> String {
        // Change the url to static 32bytes length to avoid too long
        // names while saving on disk
        let data = Data(url.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
