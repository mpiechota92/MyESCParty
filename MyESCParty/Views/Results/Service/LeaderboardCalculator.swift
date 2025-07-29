//
//  LeaderboardCalculator.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 28/07/2025.
//

import Foundation

struct LeaderboardCalculator {
    typealias Leaderboard = [LeaderboardEntry]
    
    static func calculate(from votes: [Vote], contestants: [Contestant]) -> Leaderboard {
        let contestantsMap = Dictionary(uniqueKeysWithValues: contestants.map { ($0.id, $0) })
        let points: [Int] = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
        var scores: [Int: Int] = [:]
        
        for vote in votes {
            let sortedRanking = vote.ranking.sorted { $0.key < $1.key }
            
            for (index, (_, contestantId)) in sortedRanking.enumerated() {
                guard index < 10 else { break }
                scores[contestantId, default: 0] += points[index]
            }
        }
        
        let leaderboard: [LeaderboardEntry] = scores.compactMap { (id, score) in
            guard let contestant = contestantsMap[id] else { return nil }
            return LeaderboardEntry(contestant: contestant, score: score)
        }
        
        return leaderboard.sorted { $0.score > $1.score }
    }
}
