//
//  ImageService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 02/04/2026.
//

import Foundation

class ImageService: ImageServiceProtocol {
    func fetch(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
