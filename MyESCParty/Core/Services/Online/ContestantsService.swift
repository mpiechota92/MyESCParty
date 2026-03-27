//
//  ContestantsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import Foundation

class ContestantsService: ContestantsServiceProtocol, Cachable {
    @Published private(set) var contestantsCache: [Contestant] = []
    @Published private(set) var contestantImagesCache: [Int: Data] = [:]
    
    private let imageMemoryCache = ImageMemoryCache()
    
    var cacheTimestamp: Date?
    var isFetching: Bool = false
    
    var contestantsCachePublisher: Published<[Contestant]>.Publisher {
        $contestantsCache
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
        contestantsCache = contestants
    }
    
    func getContestantImage(for id: Int) async -> Data? {
        let contestant = contestantsCache.first(where: { $0.id == id })
        let imageUrl = contestant?.imageUrl ?? "https://picsum.photos/200"
        
        guard let url = URL(string: imageUrl) else { return nil }
        
        let data = try? Data(contentsOf: url)
        
        return nil
    }
}
