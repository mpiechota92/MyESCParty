//
//  ContestantsServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

protocol ContestantsServiceProtocol {
    func fetchContestants(forceRefresh: Bool) async throws
    
    var contestantsCachePublisher: Published<[Contestant]>.Publisher { get }
}

extension ContestantsServiceProtocol {
    func fetchContestants(forceRefresh: Bool = false) async throws {
        try await fetchContestants(forceRefresh: forceRefresh)
    }
}
