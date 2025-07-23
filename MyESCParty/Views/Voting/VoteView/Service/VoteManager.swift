//
//  VoteManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 21/07/2025.
//

import Foundation

protocol VoteManagerProtocol {
    func saveVote(forStage voteStage: VoteStage, _ contestants: [Contestant]) async throws
    func loadVote(forStage voteStage: VoteStage, contestants: [Contestant]) async throws -> [Contestant]
}

class VoteManager: VoteManagerProtocol {
    private var service: VoteServiceProtocol
    
    @Published private var votes: [Vote] = []
    
    init(service: VoteServiceProtocol = VoteService()) {
        self.service = service
        
        service.votesCachePublisher
            .subscribe(on: DispatchQueue.main)
            .assign(to: &$votes)
    }
    
    // MARK: - Public methods
    
    func saveVote(forStage voteStage: VoteStage, _ contestants: [Contestant]) async throws {
        guard let vote = createVote(forStage: voteStage, contestants) else { return }
        
        try await service.saveVote(vote)
    }
    
    func loadVote(forStage voteStage: VoteStage, contestants: [Contestant]) async throws -> [Contestant] {
        
        guard let vote = try await service.loadVote(forStage: voteStage) else {
            return contestants
        }
        
        return getListFromVote(vote: vote, contestants: contestants)
    }

    // MARK: - Private methods
    
    private func createVote(forStage voteStage: VoteStage, _ contestants: [Contestant]) -> Vote? {
        guard let userId = AuthManager.shared.getUserUUID()?.uuidString else { return nil }
        
        let keyValuePairs = contestants.enumerated().map { index, contestant in
            (index, contestant.id)
        }
        
        let ranking: [Int: Int] = Dictionary(uniqueKeysWithValues: keyValuePairs)
        
        return Vote(userId: userId, voteStage: voteStage, ranking: ranking)
    }
    
    private func getListFromVote(vote: Vote, contestants: [Contestant]) -> [Contestant] {
        let sortedRanking = vote.ranking.sorted { $0.key < $1.key }
        let sortedList = sortedRanking.compactMap { _, contestantId in
            return contestants.first { $0.id == contestantId }
        }
        
        return sortedList
    }
}
