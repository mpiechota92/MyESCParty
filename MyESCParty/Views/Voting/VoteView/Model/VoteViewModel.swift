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
    @Published var filteredContestants: [Contestant] = []
    
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
        
        filteredContestants = allContestants
    }
    
    @MainActor
    func fetchContestants(stage: VoteStage) async {
        performWithLoading(type: .inline) { [weak self] in
            guard let self = self else { return }
            
            try await self.service.fetchContestants(forceRefresh: true)
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        filteredContestants.move(fromOffsets: source, toOffset: destination)
    }
    
    @MainActor
    func saveVote(stage: VoteStage) async {
        performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            try await self.voteManager.saveVote(forStage: stage, self.filteredContestants)
        }
    }
    
    @MainActor
    func contestantsFor(stage: VoteStage) async {
        switch stage {
        case .favorite:
            filteredContestants = allContestants
        case .semiFinal1:
            filteredContestants = allContestants.filter { $0.groups.contains(.firstSemi) }
        case .semiFinal2:
            filteredContestants = allContestants.filter { $0.groups.contains(.secondSemi) }
        case .grandFinal:
            filteredContestants = allContestants.filter { $0.groups.contains(.grandFinal) }
        }
        
        filteredContestants.sort { $0.country < $1.country }
        
        await loadVote(forStage: stage)
    }
    
    @MainActor
    private func loadVote(forStage stage: VoteStage) async {
        performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            self.filteredContestants = try await self.voteManager.loadVote(forStage: stage, contestants: filteredContestants)
        }
    }
}
