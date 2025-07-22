//
//  VoteService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 22/07/2025.
//

import Foundation

protocol VoteServiceProtocol {
    func saveVoteToDatabase(_ vote: Vote) async throws
    
    var votesCachePublisher: Published<[Vote]>.Publisher { get }
}

class VoteService: VoteServiceProtocol, Cachable {
    var cacheTimestamp: Date?
    
    @Published private var votesCache: [Vote] = []
    
    var votesCachePublisher: Published<[Vote]>.Publisher {
        $votesCache
    }
    
    func saveVoteToDatabase(_ vote: Vote) async throws {
        try await DatabaseManager.shared.client
            .from(.votes)
            .upsert(vote)
            .execute()
    }
    
    func fetchVotes() async {
        
    }
    
}
