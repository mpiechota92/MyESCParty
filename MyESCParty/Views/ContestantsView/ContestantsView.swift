//
//  ContestantsView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import SwiftUI

enum ContestantsGroup: String {
    case all = "All"
    case semiFinal1 = "First Semi-Final"
    case semiFinal2 = "Second Semi-Final"
    case grandFinal = "Grand Final"
}

struct ContestantsView: View {
    @StateObject private var viewModel: ContestantsViewModel = .init()
    @State private var selectedGroup: ContestantsGroup = .all
    
    private let groups: [ContestantsGroup] = [.all, .semiFinal1, .semiFinal2, .grandFinal]
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(groups, id: \.rawValue) { group in
                            let isSelected = selectedGroup == group
                            
                            Button {
                                selectGroup(group)
                            } label: {
                                Text(group.rawValue)
                                    .id(group)
                                    .font(.title2.bold())
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 5)
                                    .foregroundStyle(isSelected ? .white : .black)
                            }
                            .background {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.lightNavy)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                .onChange(of: selectedGroup) { oldValue, newValue in
                    if oldValue != newValue {
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
            
            VStack {
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(viewModel.filteredContestants) { contestant in
                            ContestantCell(contestant: contestant)
                        }
                    }
                }
            }
            
        }
        .task {
            await viewModel.fetchContestants()
        }
    }
    
    func selectGroup(_ group: ContestantsGroup) {
        selectedGroup = group
        viewModel.contestantsFor(group: group)
        print(viewModel.filteredContestants)
        print(group)
    }
}

#Preview {
    ContestantsView()
}
