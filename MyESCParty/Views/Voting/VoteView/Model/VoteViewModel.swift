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
    private let voteManager: VoteManagerProtocol
    
    init(service: ContestantsServiceProtocol = ContestantsService(),
         voteManager: VoteManagerProtocol = VoteManager()) {
        
        self.service = service
        self.voteManager = voteManager
        super.init()
        
        service.contestantsCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$allContestants)
    }
    
    @MainActor
    func fetchContestants(stage: VoteStage) async {
        performWithLoading(type: .inline) { [weak self] in
            guard let self = self else { return }
            
            try await self.service.fetchContestants(forceRefresh: true)
            self.allContestants = try await self.voteManager.loadVote(forStage: stage, contestants: allContestants)
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        allContestants.move(fromOffsets: source, toOffset: destination)
    }
    
    @MainActor
    func saveVote(stage: VoteStage) async {
        performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            try await self.voteManager.saveVote(forStage: stage, self.allContestants)
        }
    }
}
