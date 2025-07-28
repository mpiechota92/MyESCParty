//
//  ResultsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 28/07/2025.
//

import Foundation

protocol ResultsServiceProtocol {
    func fetchResults(forStage stage: VoteStage, users: [RoomParticipant]) async throws
}

class ResultsService: ResultsServiceProtocol, Cachable {
    var cacheTimestamp: Date?
    var cacheTTL: TimeInterval? = 10
    
    private var votes: [Vote] = []
    
    func fetchResults(forStage stage: VoteStage, users: [RoomParticipant]) async throws {
        let now = Date()
        let usersFilter = users.map { $0.id.uuidString }
        
        let votes: [Vote] = try await DatabaseManager.shared.client
            .from(.votes)
            .select()
            .eq(Vote.CodingKeys.voteStage.rawValue, value: stage.rawValue)
            .in(Vote.CodingKeys.userId.rawValue, values: usersFilter)
            .execute()
            .value
        
        self.votes = votes
        self.cacheTimestamp = now
    }
    
    
}
