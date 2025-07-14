//
//  ContestantsViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import Foundation

@MainActor
class ContestantsViewModel: ObservableObject {
    private let service: ContestantsServiceProtocol
    @Published var contestants: [Contestant] = []
    @Published var filteredContestants: [Contestant] = []
    
    init(service: ContestantsServiceProtocol = ContestantsService()) {
        self.service = service
        
        service.contestantsCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$contestants)
    }
    
    func fetchContestants(forceRefresh: Bool = false) async {
        do {
            try await service.fetchContestants(forceRefresh: forceRefresh)
            filteredContestants = contestants
        } catch {
            #if DEBUG
            print("Error fetching contestants: \(error)")
            #endif
        }
    }
    
    func contestantsFor(group: ContestantsGroup) {
        switch group {
        case .all:
            filteredContestants = contestants
        case .semiFinal1:
            filteredContestants = contestants.filter { $0.groups.contains(.firstSemi) }
        case .semiFinal2:
            filteredContestants = contestants.filter { $0.groups.contains(.secondSemi) }
        case .grandFinal:
            filteredContestants = contestants.filter { $0.groups.contains(.grandFinal) }
        }
        
        filteredContestants.sort { $0.country < $1.country }
    }
}
