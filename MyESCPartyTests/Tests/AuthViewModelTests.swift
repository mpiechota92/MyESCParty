//
//  AuthViewModelTests.swift
//  MyESCPartyTests
//
//  Created by Maciej Piechota on 24/07/2025.
//

import XCTest
@testable import MyESCParty

final class AuthViewModelTests: XCTestCase {
    func testSignInSuccessSetsUserAndSession() async throws {
        let mockManger = MockAuthManger()
        let viewModel = AuthViewModel(authManager: mockManger)
        
        try await viewModel.signIn(email: "test@example.com", password: "1234")
        
        XCTAssertNotNil(viewModel.user)
        XCTAssertTrue(viewModel.isSessionActive)
    }
}
