//
//  VoteView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI
import SwiftUIIntrospect

struct VoteView: View {
    @StateObject private var viewModel = VoteViewModel()

    @State private var shouldRevealOverlay: Bool = true
    @State private var scrollObserver: RevealOverlayScrollObserver?
    
    let points: [Int] = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
    
    var body: some View {
        ZStack(alignment: .bottom){
            List {
                ForEach(Array(viewModel.allContestants.enumerated()), id: \.element.id) { index, contestant in
                    
                    let points = index < 10 ? points[index] : 0
                    
                    VoteListCell(contestant: contestant, points: points)
                        .listRowInsets(EdgeInsets())
                }
                .onMove(perform: viewModel.moveItem)
            }
            .listStyle(.plain)
            .safeAreaInset(edge: .bottom) {
                if shouldRevealOverlay {
                    BaseButton(title: "Save your vote") {
                        viewModel.saveVote()
                    }
                    .padding(20)
                    .shadow(radius: 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .introspect(.scrollView, on: .iOS(.v16, .v17, .v18)) { scrollView in
            if scrollObserver == nil {
                scrollObserver = RevealOverlayScrollObserver(scrollView: scrollView, shouldRevealOverlay: $shouldRevealOverlay)
            }
        }
        .task {
            await viewModel.fetchContestants()
        }
        .animation(.easeInOut(duration: 0.2), value: shouldRevealOverlay)
    }
}

#Preview {
    VoteView()
}
