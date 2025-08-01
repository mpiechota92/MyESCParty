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

extension VoteServiceProtocol {
    func saveVoteToUserDefaults(_ vote: Vote) {
        let defaults = UserDefaults.standard
        let key = "vote_\(vote.voteStage.rawValue)"
        
        #if DEBUG
        print("Saving votes to user defaults...")
        #endif
        
        let ranking = Dictionary(uniqueKeysWithValues: vote.ranking.map {
            (String($0.key), $0.value)
        })
        
        defaults.set(ranking, forKey: key)
    }
    
    func loadVoteFromUserDefaults(forStage voteStage: VoteStage) -> Vote? {
        let defaults = UserDefaults.standard
        let key = "vote_\(voteStage.rawValue)"
        
        #if DEBUG
        print("Fetching votes from user defaults...")
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
