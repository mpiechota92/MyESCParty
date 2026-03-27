//
//  ContestantsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import Foundation

class ContestantsService: ContestantsServiceProtocol, Cachable {
    @Published private(set) var contestantsCache: [Contestant] = []
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
}
