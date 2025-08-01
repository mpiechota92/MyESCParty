//
//  LocalContestantsService.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

class LocalContestantsService: ContestantsServiceProtocol, Cachable {
    @Published private(set) var contestantsCache: [Contestant] = []
    var cacheTimestamp: Date?
    var isFetching: Bool = false
    
    var contestantsCachePublisher: Published<[Contestant]>.Publisher {
        $contestantsCache
    }
    
    func fetchContestants(forceRefresh: Bool) async throws {
        let contestants: [Contestant]? = try DemoDataReader.getDataForTable(table: .contestants)
        
        guard let contestants else {
            throw DemoDataReaderError.couldNotRead
        }
        
        contestantsCache = contestants
    }
}
