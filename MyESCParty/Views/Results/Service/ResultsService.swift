//
//  ResultsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 28/07/2025.
//

import Foundation

protocol ResultsServiceProtocol {
    func fetchResults(forStage stage: VoteStage, users: [RoomParticipant]) async throws -> [Vote]
}

class ResultsService: ResultsServiceProtocol {
    func fetchResults(forStage stage: VoteStage, users: [RoomParticipant]) async throws -> [Vote] {
        let usersFilter = users.map { $0.id.uuidString }
        
        let votes: [Vote] = try await DatabaseManager.shared.client
            .from(.votes)
            .select()
            .eq(Vote.CodingKeys.voteStage.rawValue, value: stage.rawValue)
            .in(Vote.CodingKeys.userId.rawValue, values: usersFilter)
            .execute()
            .value
        
        return votes
    }
}
