//
//  VoteView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI
import SwiftUIIntrospect

struct VoteView: View {
    @EnvironmentObject var toastManager: ToastManager
    @StateObject private var viewModel: VoteViewModel

    @State private var shouldRevealOverlay: Bool = true
    @State private var scrollObserver: RevealOverlayScrollObserver?
    @State private var selectedStage: VoteStage = .favorite
    
    private let points: [Int] = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
    
    init(viewModel: VoteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HorizontalSegmentedPicker(
                items: VoteStage.allCases,
                selectedItem: $selectedStage) { selectedStage in
                    Task {
                        await viewModel.contestantsFor(stage: selectedStage)
                    }
                }
            
            ZStack(alignment: .bottom){
                List {
                    ForEach(Array(viewModel.filteredContestants.enumerated()), id: \.element.id) { index, contestant in
                        
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
                            Task {
                                await viewModel.saveVote(stage: selectedStage)
                                
                                if let error = viewModel.error {
                                    toastManager.showToast(message: error.localizedDescription, type: .error)
                                }
                            }
                        }
                        .padding(20)
                        .shadow(radius: 8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                
                if viewModel.loadingType == .fullScreen {
                    FullScreenLoadingView()
                }
            }
            .introspect(.scrollView, on: .iOS(.v16, .v17, .v18)) { scrollView in
                if scrollObserver == nil {
                    scrollObserver = RevealOverlayScrollObserver(scrollView: scrollView, shouldRevealOverlay: $shouldRevealOverlay)
                }
            }
            .task {
                await viewModel.fetchContestants(stage: .favorite)
                await viewModel.contestantsFor(stage: selectedStage)
            }
            .animation(.easeInOut(duration: 0.2), value: shouldRevealOverlay)
            .onReceive(viewModel.$error) { error in
                guard let error else { return }
                toastManager.showErrorToast(error: error)
            }
        }
    }
}

#Preview {
    VoteView(viewModel: VoteViewModel())
}
