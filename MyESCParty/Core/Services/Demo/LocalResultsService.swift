//
//  LocalResultsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

class LocalResultsService: ResultsServiceProtocol {
    func fetchResults(forStage stage: VoteStage, users: [RoomParticipant]) async throws -> [Vote] {
        guard let votes: [Vote] = try DemoDataReader.getDataForTable(table: .votes) else {
            return []
        }
        
        let stageVotes = votes.filter { $0.voteStage == stage }
        let usersVotes = stageVotes.filter { vote in
            users.contains { user in
                let voteUserUUID = UUID(uuidString: vote.userId)
                return user.id == voteUserUUID
            }
        }
        
        return usersVotes
    }
}
