//
//  VoteManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 21/07/2025.
//

import Foundation

protocol VoteManagerProtocol {
    func saveVote(forStage voteStage: VoteStage, _ contestants: [Contestant]) async throws
}

class VoteManager: VoteManagerProtocol {
    private var service: VoteServiceProtocol
    
    init(service: VoteServiceProtocol = VoteService()) {
        self.service = service
    }
    
    func saveVote(forStage voteStage: VoteStage, _ contestants: [Contestant]) async throws {
        guard let vote = createVote(forStage: voteStage, contestants) else { return }
        
        saveVoteToUserDefaults(vote)
        try await saveVoteToDatabase(vote)
    }
    
    private func createVote(forStage voteStage: VoteStage, _ contestants: [Contestant]) -> Vote? {
        guard let userId = AuthManager.shared.getUserUUID()?.uuidString else { return nil }
        
        let keyValuePairs = contestants.enumerated().map { index, contestant in
            (index, contestant.id)
        }
        
        let ranking: [Int: Int] = Dictionary(uniqueKeysWithValues: keyValuePairs)
        
        return Vote(userId: userId, voteStage: voteStage, ranking: ranking)
    }
    
    func getListFromVote(vote: Vote, contestants: [Contestant]) -> [Contestant] {
        let sortedRanking = vote.ranking.sorted { $0.value < $1.value }
        
        let sortedList = sortedRanking.compactMap { _, contestantId in
            return contestants.first { $0.id == contestantId }
        }
        
        return sortedList
    }
    
    
    private func saveVoteToUserDefaults(_ vote: Vote) {
        let defaults = UserDefaults.standard
        let key = "vote_\(vote.voteStage.rawValue)"
        
        let ranking = Dictionary(uniqueKeysWithValues: vote.ranking.map {
            (String($0.key), $0.value)
        })
        
        defaults.set(ranking, forKey: key)
    }
    
    private func saveVoteToDatabase(_ vote: Vote) async throws {
        try await service.saveVoteToDatabase(vote)
    }
}
