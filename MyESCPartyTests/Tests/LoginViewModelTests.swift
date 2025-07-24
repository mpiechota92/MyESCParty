//
//  LoginViewModelTests.swift
//  MyESCPartyTests
//
//  Created by Maciej Piechota on 24/07/2025.
//

import XCTest
@testable import MyESCParty

final class LoginViewModelTests: XCTestCase {
    let allModes: [AuthType] = [.signIn, .signUp]
    
    private func makeViewModel(
        email: String = "test@test.com",
        userName: String = "TestUser",
        password: String = "password123",
        repeatPassword: String = "password123",
        authType: AuthType = .signIn
    ) -> LoginViewModel {
        let vm = LoginViewModel()
        vm.email = email
        vm.username = userName
        vm.password = password
        vm.repeatPassword = repeatPassword
        vm.authType = authType
        
        return vm
    }
    
    // MARK: - Email Validation
    
    func testEmptyEmailInAllModesIsInvalidAndShowsError() {
        for mode in allModes {
            XCTContext.runActivity(named: "Testing mode \(mode)") { _ in
                let viewModel = makeViewModel(email: "", authType: mode)
                let isValid = viewModel.validate()
                
                XCTAssertFalse(isValid, "Validation should fail for empty email in mode \(mode)")
                XCTAssertNotNil(viewModel.validationError, "Validation error should not be nil for empty email in mode \(mode)")
            }
        }
    }
    
    func testInvlidEmailInAllModesIsInvalidAndShowsError() {
        for mode in allModes {
            XCTContext.runActivity(named: "Testing mode \(mode)") { _ in
                let viewModel = makeViewModel(email: "invalidEmail", authType: mode)
                let isValid = viewModel.validate()
                
                XCTAssertFalse(isValid, "Validation should fail for invalid email in mode \(mode)")
                XCTAssertNotNil(viewModel.validationError, "Validation error should not be nil for invalid email in mode \(mode)")
            }
        }
    }
    
    func testValidEmailInAllModesIsValidAndShowsNoError() {
        for mode in allModes {
            XCTContext.runActivity(named: "Testing mode \(mode)") { _ in
                let viewModel = makeViewModel(email: "test@test.com", authType: mode)
                let isValid = viewModel.validate()
                
                XCTAssertTrue(isValid, "Validation should not fail for valid email in mode \(mode)")
                XCTAssertNil(viewModel.validationError, "Validation error should be nil for valid email in mode \(mode)")
            }
        }
    }
    
    // MARK: - Password Validation
    
    func testEmptyPasswordInAllModesIsInvalidAndShowsError() {
        for mode in allModes {
            XCTContext.runActivity(named: "Testing mode \(mode)") { _ in
                let viewModel = makeViewModel(password: "", authType: mode)
                let isValid = viewModel.validate()
                
                XCTAssertFalse(isValid, "Validation should fail for empty password in mode \(mode)")
                XCTAssertNotNil(viewModel.validationError, "Validation error should not be nil for empty password in mode \(mode)")
            }
        }
    }
    
    func testDifferentPasswordsNotMatchInSignUpModeIsInvalidAndShowsError() {
        let viewModel = makeViewModel(password: "testPassword123", repeatPassword: "differentPassword123", authType: .signUp)
        let isValid = viewModel.validate()
        
        XCTAssertFalse(isValid, "Validation should fail for not matching passwords in sign up mode")
        XCTAssertNotNil(viewModel.validationError, "Validation error should not be nil for not matching passwords in sign up mode")
    }
    
    func testMatchingPasswordsInAllModesAreValidAndShowsNoError() {
        for mode in allModes {
            XCTContext.runActivity(named: "Testing mode \(mode)") { _ in
                let viewModel = makeViewModel(password: "testPassword123", repeatPassword: "testPassword123", authType: mode)
                let isValid = viewModel.validate()
                
                XCTAssertTrue(isValid, "Validation should succeed for matching passwords in mode \(mode)")
                XCTAssertNil(viewModel.validationError, "Validation error should be nil for matching passwords in mode \(mode)")
            }
        }
    }
}
