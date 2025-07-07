//
//  VoteViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 23/05/2025.
//

import Foundation

class VoteViewModel: ObservableObject {
    @Published var items: [VoteListItem]  = [
        VoteListItem(name: "Poland"),
        VoteListItem(name: "England"),
        VoteListItem(name: "Slovenia"),
        VoteListItem(name: "Poland"),
        VoteListItem(name: "Poland"),
        VoteListItem(name: "Poland"),
        VoteListItem(name: "Poland")
    ]
    
    func move(from sourceIndex: IndexSet, to destination: Int) {
        items.move(fromOffsets: sourceIndex, toOffset: destination)
    }
    
}
