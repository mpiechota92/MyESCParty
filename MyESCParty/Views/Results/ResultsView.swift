//
//  ResultsView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 29/07/2025.
//

import SwiftUI

struct ResultsView: View {
    @StateObject private var viewModel: ResultsViewModel = ResultsViewModel()
    @State private var selectedStage: VoteStage = .favorite
    
    private let roomId: Int
    
    init(roomId: Int = Room.publicRoomId) {
        self.roomId = roomId
    }
    
    var body: some View {
        VStack {
            HorizontalSegmentedPicker(
                items: VoteStage.allCases,
                selectedItem: $selectedStage) { _ in
                    Task { await fetchResults() }
                }
            
            ZStack(alignment: .bottom){
                List {
                    ForEach(Array(viewModel.leaderboard.enumerated()), id: \.element.id) { index, entry in
                        ResultsEntryCell(leaderboardEntry: entry, index: index)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await fetchResults()
                }
                
                if viewModel.loadingType == .fullScreen {
                    FullScreenLoadingView()
                }
            }
        }
        .task {
            await fetchResults()
        }
    }
    
    @Sendable
    private func fetchResults() async {
        await viewModel.fetchResults(forStage: selectedStage, roomId: roomId)
    }
}

#Preview {
    ResultsView()
}
