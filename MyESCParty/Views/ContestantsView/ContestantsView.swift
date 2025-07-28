//
//  ContestantsView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import SwiftUI

enum ContestantsGroup: String, SegmentedPickerElement {
    case all = "All"
    case semiFinal1 = "First Semi-Final"
    case semiFinal2 = "Second Semi-Final"
    case grandFinal = "Grand Final"
}

struct ContestantsView: View {
    @StateObject private var viewModel: ContestantsViewModel = .init()
    @State private var selectedGroup: ContestantsGroup = .all
    
    var body: some View {
        NavigationStack {
            HorizontalSegmentedPicker(
                items: ContestantsGroup.allCases,
                selectedItem: $selectedGroup) { selectedGroup in
                viewModel.contestantsFor(group: selectedGroup)
            }
            
            List {
                ForEach(viewModel.filteredContestants) { contestant in
                    ContestantCell(contestant: contestant)
                }
            }
            .listStyle(.plain)
        }
        .task {
            await viewModel.fetchContestants()
            viewModel.contestantsFor(group: selectedGroup)
        }
    }
}

#Preview {
    ContestantsView()
}
