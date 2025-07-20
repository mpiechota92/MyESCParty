//
//  VoteListCell.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

struct VoteListCell: View {
    let contestant: Contestant
    let points: Int
    
    var color: Color {
        switch points {
        case 12:
            return .gold
        case 10:
            return .silver
        case 8:
            return .bronze
        default:
            return .black
        }
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            ContestantView(contestant: contestant, cellType: .dragAndDrop)
            
            if points > 0 {
                Text("\(points)")
                    .foregroundStyle(color)
                    .font(.title)
                    .bold()
                    .padding(.trailing, 50)
            }
        }
    }
}

#Preview {
    VoteListCell(contestant: Contestant.mockSweeden, points: 12)
}

