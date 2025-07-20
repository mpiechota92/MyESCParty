//
//  VoteView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

struct VoteView: View {
    @StateObject private var viewModel = VoteViewModel()
    
    @State private var draggedItem: Contestant?
    @State private var draggedFromTopList: Bool = false
    
    let points: [Int] = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(viewModel.allContestants.enumerated()), id: \.element.id) { index, contestant in
                    
                    let points = index < 10 ? points[index] : 0
                    
                    VoteListCell(contestant: contestant, points: points)
                        .listRowInsets(EdgeInsets())
                }
                .onMove(perform: viewModel.moveItem)
            }
            .listStyle(.plain)
            
            
        }
        .task {
            await viewModel.fetchContestants()
        }
    }
}

#Preview {
    VoteView()
}
