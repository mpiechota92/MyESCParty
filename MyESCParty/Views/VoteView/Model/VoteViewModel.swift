//
//  VoteViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 23/05/2025.
//

import Foundation
import Combine

class VoteViewModel: ObservableObject {
    @Published var allContestants: [Contestant] = []
    private let service: ContestantsServiceProtocol
    
    init(service: ContestantsServiceProtocol = ContestantsService()) {
        self.service = service
        
        service.contestantsCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$allContestants)
        
        // TODO: fetch the contestants on init in view
    }
    
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
