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
    
    func fetchVotes() async throws -> [Vote] {
        let votes: [Vote]? = try DemoDataReader.getDataForTable(table: .votes)
        
        guard let votes else {
            throw DemoDataReaderError.couldNotRead
        }
        
        votesCache = votes
        return votes
    }
    
    func saveVote(_ vote: Vote) async throws {
        saveVoteToUserDefaults(vote)
    }
    
    func loadVote(forStage voteStage: VoteStage) async throws -> Vote? {
        if let savedVote = loadVoteFromUserDefaults(forStage: voteStage) {
            return savedVote
        }
        
        let votes = try await fetchVotes()
        let vote = votesCache.first { $0.voteStage == voteStage }
        
        guard let vote else {
            return nil
        }
        
        return vote
    }
}
