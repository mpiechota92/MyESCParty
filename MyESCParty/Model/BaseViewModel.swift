//
//  BaseViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 17/07/2025.
//

import Foundation

enum LoadingType {
    case inline
    case fullScreen
    case none
}

class BaseViewModel: ObservableObject {
    @Published var error: Error?
    @Published var loadingType: LoadingType = .none
    
    @MainActor
    func performWithLoading(type: LoadingType, _ operation: @escaping @MainActor () async throws -> Void) {
        guard loadingType == .none else { return }
        self.loadingType = type
        error = nil
        
        Task {
            defer { self.loadingType = .none }
            do {
                try await operation()
            } catch {
                self.error = error
            }
        }
    }
}
