//
//  ContestantsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import Foundation

class ContestantsService: ContestantsServiceProtocol, Cachable {
    @Published private(set) var contestants: [Contestant] = []
    @Published private(set) var contestantsImages: [Int: Data] = [:]
    
    private let imageManager: ImageManager = ImageManager()
    
    var cacheTimestamp: Date?
    var isFetching: Bool = false
    
    var contestantsCachePublisher: Published<[Contestant]>.Publisher {
        $contestants
    }
    
    func fetchContestants(forceRefresh: Bool = false) async throws {
        if isFetching {
            return
        }
        
        isFetching = true
        defer { isFetching = false }
        
        let now = Date()
        
        if !forceRefresh, let timestamp = cacheTimestamp, now.timeIntervalSince(timestamp) < cacheTTL {
            return
        }
        
        let contestants: [Contestant] = try await DatabaseManager.shared.client
            .from(.contestants)
            .select()
            .execute()
            .value
        
        cacheTimestamp = now
        self.contestants = contestants
    }
    
//    func getContestantImage(for id: Int) async throws -> Data {
//        let contestant = contestants.first(where: { $0.id == id })
//        let imageUrl = contestant?.imageUrl ?? "https://picsum.photos/200"
//        
//        let data = try await imageManager.image(for: imageUrl)
//        
//        return data
//    }
}
