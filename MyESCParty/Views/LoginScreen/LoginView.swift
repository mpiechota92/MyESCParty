//
//  LoginView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

enum LoginViewField: Hashable {
    case email, password, repeatPassword, username
}

struct LoginView: View {
    @EnvironmentObject var toastManager: ToastManager
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject private var viewModel: LoginViewModel = LoginViewModel()
    
    @State private var showCreateUser = false
    
    @FocusState private var focusedField: LoginViewField?
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                LoginFieldsView(viewModel: viewModel)
                
                Spacer()
                
                VStack {
                    Button(viewModel.authType == .signIn ? "Sign in" : "Sign up") {
                        Task {
                            await viewModel.submit(authViewModel: authViewModel)
                        }
                    }
                    .foregroundStyle(.black)
                    .padding()
                    
                    Button(viewModel.authType == .signIn ? "Create new user" : "Already have an account") {
                        viewModel.authType = viewModel.authType == .signIn ? .signUp : .signIn
                    }
                    .foregroundStyle(.red)
                    .padding(.bottom)
                    
                    
                }
            }
            
            if viewModel.loadingType == .fullScreen {
                FullScreenLoadingView()
            }
        }
        .onReceive(authViewModel.$error) { error in
            guard let error else { return }
            toastManager.showErrorToast(error: error)
        }
        .onReceive(viewModel.$validationError) { message in
            guard let message else { return }
            toastManager.showToast(message: message, type: .info)
        }
    }
    
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
        .environmentObject(ToastManager())
}
