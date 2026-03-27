//
//  ImageDiskCache.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 27/03/2026.
//

import Foundation

final class ImageDiskCache {
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
        try? data.write(to: url)
    }
    
    func load(for key: String) -> Data? {
        let url = fileURL(for: key)
        return try? Data(contentsOf: url)
    }
}
