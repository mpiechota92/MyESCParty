//
//  ImageDiskCache.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 27/03/2026.
//

import Foundation

final class ImageDiskCache {
    private let cacheTTL: TimeInterval = -60 // 1 minute for the time being
    
    private let directory: URL = {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let folder = base.appendingPathComponent("ImageCache", isDirectory: true)
        
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        
        return folder
    }()
    
    func fileURL(for key: String) -> URL {
        directory.appendingPathComponent(key, isDirectory: false)
    }
    
    func save(_ data: Data, for key: String) {
        let url = fileURL(for: key)
        do {
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(for key: String) -> Data? {
        let url = fileURL(for: key)
        if isExpired(url) { return nil }
        
        return try? Data(contentsOf: url)
    }
    
    func isExpired(_ fileURL: URL) -> Bool {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let date = attributes[.modificationDate] as? Date else { return true }
        return date < Date().addingTimeInterval(cacheTTL)
    }
}
