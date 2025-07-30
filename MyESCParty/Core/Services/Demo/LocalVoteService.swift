//
//  LocalVoteService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

class LocalVoteService: VoteServiceProtocol, Cachable {
    var cacheTimestamp: Date?
    @Published private var votesCache: [Vote] = []
    
    var votesCachePublisher: Published<[Vote]>.Publisher {
        $votesCache
    }
    
    func saveVote(_ vote: Vote) async throws {
        
    }
    
    func loadVote(forStage: VoteStage) async throws -> Vote? {
        nil
    }
}
