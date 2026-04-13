//
//  ResultsEntryCell.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 29/07/2025.
//

import SwiftUI

struct ResultsEntryCell: View {
    let leaderboardEntry: LeaderboardEntry
    let index: Int
    
    var color: Color {
        switch index {
        case 0:
            return .gold
        case 1:
            return .silver
        case 2:
            return .bronze
        default:
            return .black
        }
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            ContestantView(contestant: leaderboardEntry.contestant, cellType: .none, size: 100)
                .overlay(alignment: .bottomTrailing) {
                    Text("\(index + 1).")
                        .font(.caption)
                        .padding(5)
                }
            
            Text("\(leaderboardEntry.score)")
                .foregroundStyle(color)
                .font(.title)
                .bold()
                .padding(.trailing, 50)
            
        }
    }
}

#Preview {
    ResultsEntryCell(leaderboardEntry: LeaderboardEntry(contestant: .mockFrance, score: 321), index: 0)
        .environmentObject(ImageManager())
}
