//
//  VoteService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 22/07/2025.
//

import Foundation

protocol VoteServiceProtocol {
    func saveVote(_ vote: Vote) async throws
    func loadVote(forStage: VoteStage) async throws -> Vote?
    
    var votesCachePublisher: Published<[Vote]>.Publisher { get }
}

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Fetching votes...")
        }
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
    
    private func saveVoteToUserDefaults(_ vote: Vote) {
        let defaults = UserDefaults.standard
        let key = "vote_\(vote.voteStage.rawValue)"
        
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("Saving votes from user defaults...")
        }
        #endif
        
        let ranking = Dictionary(uniqueKeysWithValues: vote.ranking.map {
            (String($0.key), $0.value)
        })
        
        defaults.set(ranking, forKey: key)
    }
    
    private func loadVoteFromUserDefaults(forStage voteStage: VoteStage) -> Vote? {
        let defaults = UserDefaults.standard
        let key = "vote_\(voteStage.rawValue)"
        
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Fetching votes from user defaults...")
        }
        #endif
        
        guard let ranking = defaults.dictionary(forKey: key) as? [String: Int] else {
            return nil
        }
        
        let voteRanking: [Int: Int] = Dictionary(uniqueKeysWithValues: ranking.compactMap {
            guard let key = Int($0.key) else { return nil }
            return (key, $0.value)
        })
        
        let vote = Vote(voteStage: voteStage, ranking: voteRanking)
        return vote
    }
}
