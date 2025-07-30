//
//  VoteServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

protocol VoteServiceProtocol {
    func saveVote(_ vote: Vote) async throws
    func loadVote(forStage: VoteStage) async throws -> Vote?
    
    var votesCachePublisher: Published<[Vote]>.Publisher { get }
}
