//
//  ResultsServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

protocol ResultsServiceProtocol {
    func fetchResults(forStage stage: VoteStage, users: [RoomParticipant]) async throws -> [Vote]
}
