//
//  AppEnvironment.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 30/07/2025.
//

import Foundation

final class AppEnvironment: ObservableObject {
    static let shared = AppEnvironment()
    
    private var services: [ObjectIdentifier: Any] = [:]
    private let isDemo: Bool
    
    private init() {
        self.isDemo = UserDefaults.standard.bool(forKey: "demo_mode")
        registerServices()
    }
    
    private func registerServices() {
        let factories: [() -> Void] = [
            registerAuthServices,
            registerRoomServices,
            registerContestantServices,
            registerVoteServices,
            registerResultsServices,
            registerImageServices
        ]
        
        factories.forEach { $0() }
    }
    
    private func registerAuthServices() {
        register(resolveService(
            demo: LocalAuthManager(),
            online: AuthManager.shared) as AuthManagerProtocol)
    }
    
    private func registerRoomServices() {
        register(resolveService(
            demo: LocalRoomService(),
            online: RoomService()) as RoomServiceProtocol)
        register(resolveService(
            demo: LocalRoomCreationService(),
            online: RoomCreationService()) as RoomCreationServiceProtocol)
        register(resolveService(
            demo: LocalRoomListService(),
            online: RoomListService()) as RoomListServiceProtocol)
    }
    
    private func registerContestantServices() {
        register(resolveService(
            demo: LocalContestantsService(),
            online: ContestantsService()) as ContestantsServiceProtocol)
    }
    
    private func registerVoteServices() {
        register(resolveService(
            demo: LocalVoteService(),
            online: VoteService()) as VoteServiceProtocol)
        register(VoteManager(service: resolve()) as VoteManagerProtocol)
    }
    
    private func registerResultsServices() {
        register(resolveService(
            demo: LocalResultsService(),
            online: ResultsService()) as ResultsServiceProtocol)
    }
    
    private func registerImageServices() {
        register(resolveService(
            demo: LocalImageService(),
            online: ImageService()) as ImageServiceProtocol)
    }
    // MARK: - Helpers
    
    private func resolveService<T>(demo: T, online: T) -> T {
        isDemo ? demo : online
    }
    
    func register<T>(_ service: T) {
        let key = ObjectIdentifier(T.self)
        services[key] = service
    }
    
    func resolve<T>() -> T {
        let key = ObjectIdentifier(T.self)
        guard let service = services[key] as? T else {
            fatalError("Service \(T.self) has not been registered!")
        }
        return service
    }
}
