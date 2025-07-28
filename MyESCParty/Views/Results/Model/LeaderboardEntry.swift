//
//  LeaderboardEntry.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 28/07/2025.
//

import Foundation

struct LeaderboardEntry: Codable, Identifiable {
    let contestant: Contestant
    let score: Int
    
    var id: Int {
        contestant.id
    }
}

func + (lhs: LeaderboardEntry, rhs: LeaderboardEntry) -> LeaderboardEntry {
    precondition(lhs.contestant.id == rhs.contestant.id, "Cannot add results for different contestants")
    
    let newScore = lhs.score + rhs.score
    return LeaderboardEntry(contestant: lhs.contestant, score: newScore)
}

extension Array where Element == LeaderboardEntry {
    static func + (lhs: [LeaderboardEntry], rhs: [LeaderboardEntry]) -> [LeaderboardEntry] {
        let rhsMap = Dictionary(uniqueKeysWithValues: rhs.map { ($0.contestant.id, $0) })

        let combinedResults: [LeaderboardEntry] = lhs.compactMap { lhsResult in
            guard let rhsResult = rhsMap[lhsResult.contestant.id] else {
                return nil
            }
            return lhsResult + rhsResult
        }
        
        return combinedResults.sorted { $0.score > $1.score }
    }
}

