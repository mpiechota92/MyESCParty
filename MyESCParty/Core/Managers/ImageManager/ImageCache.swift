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
    
    func image(for path: String) -> Data? {
        let memoryData = memory.get(for: path)
        if let memoryData {
            return memoryData
        }
        
        let diskData = disk.load(for: cacheKey(for: path))
        if let diskData {
            memory.set(diskData, for: path)
            return diskData
        }
        
        return nil
    }
    
    func saveImage(_ data: Data, fileName url: String) {
        memory.set(data, for: url)
        disk.save(data, for: cacheKey(for: url))
    }
    
    func saveProfilePicture(_ data: Data, profile: Profile) {
        let version = profile.avatarVersion + 1
        let url = "\(profile.id)_\(version)"
        saveImage(data, fileName: url)
    }
    
    func profilePicture(for profile: Profile) -> Data? {
        let url = "\(profile.id)_\(profile.avatarVersion)"
        return image(for: url)
    }
    
    private func deleteOldVersion(for profile: Profile) {
        //TODO
    }
    
    private func cacheKey(for url: String) -> String {
        // Change the url to static 32bytes length to avoid too long
        // names while saving on disk
        let data = Data(url.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
