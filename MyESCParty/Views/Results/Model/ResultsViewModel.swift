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
    
    @Published private var users: [RoomParticipant] = []
    
    @Published var leaderboard: Leaderboard = []
    
    let contestants: [Contestant]
    
    init(resultsService: ResultsServiceProtocol = ResultsService(),
         roomService: RoomServiceProtocol = RoomService(),
         contestants: [Contestant]) {
        self.resultsService = resultsService
        self.roomService = roomService
        self.contestants = contestants
        super.init()
        
        roomService.usersCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$users)
    }
    
    @MainActor
    func fetchResults(forStage stage: VoteStage, roomId: Int) async {
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            try await self.roomService.fetchUsers(roomId: roomId, forceRefresh: true)
            let votes = try await self.resultsService.fetchResults(forStage: stage, users: self.users)
            
            self.leaderboard = LeaderboardCalculator.calculate(from: votes, contestants: self.contestants)
        }
    }
    
    private func prepareUsersForResults() -> [String] {
        users.map { $0.id.uuidString }
    }
}
