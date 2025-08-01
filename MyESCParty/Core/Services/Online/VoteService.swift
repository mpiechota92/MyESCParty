//
//  VoteService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 22/07/2025.
//

import Foundation

class VoteService: VoteServiceProtocol, Cachable {
    var cacheTimestamp: Date?
    
    @Published private var votesCache: [Vote] = []
    
    var votesCachePublisher: Published<[Vote]>.Publisher {
        $votesCache
    }
    
    func saveVote(_ vote: Vote) async throws {
        saveVoteToUserDefaults(vote)
        try await saveVoteToDatabase(vote)
    }
    
    func loadVote(forStage voteStage: VoteStage) async throws -> Vote? {
        let didFetchVotes = try await fetchVotes()
        
        if didFetchVotes {
            let vote = votesCache.first { $0.voteStage == voteStage }
            guard let vote else {
                return nil
            }
            
            return vote
        }
        
        return loadVoteFromUserDefaults(forStage: voteStage)
    }
    
    private func fetchVotes() async throws -> Bool {
        let now = Date()
        
        if let timestamp = cacheTimestamp, now.timeIntervalSince(timestamp) < cacheTTL {
            return false
        }
        
        guard let userId = AuthManager.shared.getUserUUID()?.uuidString else {
            // TODO: throw error?
            return false
        }
        
        #if DEBUG
        print("Fetching votes...")
        #endif
        
        let votes: [Vote] = try await DatabaseManager.shared.client
            .from(.votes)
            .select()
            .eq(Vote.CodingKeys.userId.rawValue, value: userId)
            .execute()
            .value
        
        cacheTimestamp = now
        votesCache = votes
        
        return true
    }
    
    private func saveVoteToDatabase(_ vote: Vote) async throws {
        try await DatabaseManager.shared.client
            .from(.votes)
            .upsert(vote)
            .execute()
    }
}
