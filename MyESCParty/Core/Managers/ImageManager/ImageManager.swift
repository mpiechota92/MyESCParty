//
//  ImageManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 02/04/2026.
//

import SwiftUI

enum ImageError: Error {
    case invalidImageData
}

class ImageManager: ObservableObject {
    private let imageCache = ImageCache.shared
    private let service: ImageServiceProtocol
    
    init(service: ImageServiceProtocol = ImageService()) {
        self.service = service
    }
    
    func image(for url: String?) async throws -> UIImage {
//        guard let url else {
//            // TODO: show own empty image?
//            return UIImage()
//        }
        let imageUrl = url ?? "https://picsum.photos/200"
        if let cached = imageCache.image(for: imageUrl), let image = UIImage(data: cached) {
            return image
        }
        
        let data = try await service.fetch(from: imageUrl)
        
        guard !data.isEmpty,
              let image = UIImage(data: data) else {
            throw ImageError.invalidImageData
        }
        
        imageCache.saveImage(data, fileName: imageUrl)
        return image
    }
}
