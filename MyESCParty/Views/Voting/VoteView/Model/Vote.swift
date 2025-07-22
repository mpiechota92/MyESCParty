//
//  Vote.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 21/07/2025.
//

import Foundation

enum VoteStage: String, Codable {
    case firstSemi = "firstSemi"
    case secondSemi = "secondSemi"
    case grandFinal = "grandFinal"
    case favorite = "favorite"
}

struct Vote: Codable, Hashable {
    let userId: String
    let voteStage: VoteStage
    let ranking: [Int: Int]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case voteStage = "stage"
        case ranking = "vote_distribution"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        voteStage = try container.decode(VoteStage.self, forKey: .voteStage)
        
        let stringDict = try container.decode([String: Int].self, forKey: .ranking)
        ranking = Dictionary(uniqueKeysWithValues: stringDict.compactMap { key, value in
            guard let intKey = Int(key) else { return nil }
            return (intKey, value)
        })
    }
    
    init(userId: String = "", voteStage: VoteStage, ranking: [Int: Int]) {
        self.userId = userId
        self.voteStage = voteStage
        self.ranking = ranking
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(voteStage, forKey: .voteStage)
        
        let stringDict = Dictionary(uniqueKeysWithValues: ranking.map { key, value in
            (String(key), value)
        })
        
        try container.encode(stringDict, forKey: .ranking)
    }
}
