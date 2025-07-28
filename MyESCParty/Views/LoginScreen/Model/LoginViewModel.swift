//
//  LoginViewModel.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 23/07/2025.
//

import Foundation

enum AuthType {
    case signIn
    case signUp
}

class LoginViewModel: BaseViewModel {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    
    @Published var authType: AuthType = .signIn
    
    @Published var validationError: String? = nil
    
    @MainActor
    func submit(authViewModel: AuthViewModel) async {
        guard validate() else { return }
        
        await performWithLoading(type: .fullScreen) { [weak self] in
            guard let self = self else { return }
            
            switch self.authType {
            case .signIn:
                try await authViewModel.signIn(email: self.email, password: self.password)
            case .signUp:
                try await authViewModel.signUp(email: self.email, username: self.username, password: self.password)
            }
        }
    }
    
    func validate() -> Bool {
        switch authType {
        case .signIn:
            let validEmail = email.isEmailValid() && !email.isEmpty
            let validPassword = !password.isEmpty
            
            if validEmail && validPassword {
                return true
            } else {
                validationError = "Incorrect login data"
                return false
            }
        case .signUp:
            let validEmail = email.isEmailValid() && !email.isEmpty
            let validPasswords = !password.isEmpty && !repeatPassword.isEmpty && password == repeatPassword
            
            if validEmail && validPasswords {
                return true
            } else {
                validationError = "Incorrect signup data"
                return false
            }
        }
    }
}
