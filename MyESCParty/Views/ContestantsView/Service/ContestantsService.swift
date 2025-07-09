//
//  ContestantsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import Foundation
import Combine

protocol ContestantsServiceProtocol {
    func fetchContestants(forceRefresh: Bool) async throws
}

class ContestantsService: ContestantsServiceProtocol, Cachable {
    @Published private(set) var contestantsCache: [Contestant] = []
    var cacheTimestamp: Date?
    
    
    func fetchContestants(forceRefresh: Bool = false) async throws {
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
