//
//  ResultsView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 29/07/2025.
//

import SwiftUI

struct ResultsView: View {
    @StateObject var viewModel: ResultsViewModel
    
    @State private var selectedStage: VoteStage = .favorite
    
    private let roomId: Int
    
    init(contestants: [Contestant], roomId: Int = Room.publicRoomId) {
        self._viewModel = StateObject(wrappedValue: ResultsViewModel(contestants: contestants))
        self.roomId = roomId
    }
    
    var body: some View {
        VStack {
            HorizontalSegmentedPicker(
                items: VoteStage.allCases,
                selectedItem: $selectedStage) { selectedStage in
                    Task {
                        await viewModel.fetchResults(forStage: selectedStage, roomId: roomId)
                    }
                }
            
            ZStack(alignment: .bottom){
                List {
                    ForEach(viewModel.leaderboard) { entry in
                        ContestantView(contestant: entry.contestant, cellType: .none)
                    }
                }
                .listStyle(.plain)
                
                if viewModel.loadingType == .fullScreen {
                    FullScreenLoadingView()
                }
            }
        }
        .task {
            await viewModel.fetchResults(forStage: selectedStage, roomId: roomId)
        }
    }
}

#Preview {
    ResultsView(contestants: [.mockFrance, .mockGermany, .mockPoland])
}
