//
//  ResultsViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 28/07/2025.
//

import Foundation

class ResultsViewModel: BaseViewModel {
    typealias Leaderboard = [LeaderboardEntry]
    
    private let resultsService: ResultsServiceProtocol
    private let roomService: RoomServiceProtocol
    private let contestantsService: ContestantsServiceProtocol
    
    @Published private var users: [Int: [RoomParticipant]] = [:]
    @Published private var contestants: [Contestant] = []
    
    @Published var leaderboard: Leaderboard = []
    
    init(resultsService: ResultsServiceProtocol = ResultsService(),
         roomService: RoomServiceProtocol = RoomService(),
         contestantsService: ContestantsServiceProtocol = ContestantsService()) {
        self.resultsService = resultsService
        self.roomService = roomService
        self.contestantsService = contestantsService
        super.init()
        
        roomService.usersCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$users)
        
        contestantsService.contestantsCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$contestants)
    }
    
    @MainActor
    func fetchResults(forStage stage: VoteStage, roomId: Int) async {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            try await self.roomService.fetchUsers(roomId: roomId, forceRefresh: true)
            try await self.contestantsService.fetchContestants()
            let votes = try await self.resultsService.fetchResults(forStage: stage, users: self.users[roomId] ?? [])
            
            self.leaderboard = LeaderboardCalculator.calculate(from: votes, contestants: self.contestantsFor(stage: stage))
        }
    }
    
    // TODO: Use the same enum for stages as for groups
    private func contestantsFor(stage: VoteStage) -> [Contestant] {
        var filteredContestants: [Contestant] = []
        
        switch stage {
        case .favorite:
            filteredContestants = contestants
        case .semiFinal1:
            filteredContestants = contestants.filter { $0.groups.contains(.firstSemi) }
        case .semiFinal2:
            filteredContestants = contestants.filter { $0.groups.contains(.secondSemi) }
        case .grandFinal:
            filteredContestants = contestants.filter { $0.groups.contains(.grandFinal) }
        }
        
        filteredContestants.sort { $0.country < $1.country }
        return filteredContestants
    }
}
