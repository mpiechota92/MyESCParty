//
//  VoteViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 23/05/2025.
//

import Foundation
import Combine

class VoteViewModel: BaseViewModel {
    @Published var allContestants: [Contestant] = []
    private let service: ContestantsServiceProtocol
    
    init(service: ContestantsServiceProtocol = ContestantsService()) {
        self.service = service
        super.init()
        
        service.contestantsCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$allContestants)
    }
    
    @MainActor
    func fetchContestants() async {
        performWithLoading(type: .inline) { [weak self] in
            guard let self = self else { return }
            
            try await self.service.fetchContestants(forceRefresh: true)
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        allContestants.move(fromOffsets: source, toOffset: destination)
    }
    
    func saveVote() {
        
    }
    
    func loadVote() {
        
    }
}
