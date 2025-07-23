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
        GeometryReader { geometry in
            ZStack {
                
                // TODO: The fields should not move when the keyboard is shown
                VStack {
                    Spacer()
                    VStack {
                        if let error = authViewModel.error {
                            Text(error.localizedDescription)
                        }
                        
                        TextField("Email", text: $viewModel.email)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .onSubmit {
                                focusedField = viewModel.authType == .signUp ? .username : .password
                            }
                        
                        if viewModel.authType == .signUp {
                            TextField("username", text: $viewModel.username)
                                .focused($focusedField, equals: .username)
                                .submitLabel(.next)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                                .onSubmit {
                                    focusedField = .password
                                }
                        }
                        
                        SecureField("Password", text: $viewModel.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(showCreateUser ? .next : .done)
                            .padding()
                            .onSubmit {
                                if viewModel.authType == .signUp {
                                    focusedField = .repeatPassword
                                } else {
                                    Task {
                                        await viewModel.submit(authViewModel: authViewModel)
                                    }
                                }
                            }
                        
                        if viewModel.authType == .signUp {
                            SecureField("Repeat password", text: $viewModel.repeatPassword)
                                .focused($focusedField, equals: .repeatPassword)
                                .padding()
                                .onSubmit {
                                    Task {
                                        await viewModel.submit(authViewModel: authViewModel)
                                    }
                                }
                        }
                    }
                    
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
                        
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.3)
                    
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
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
        .environmentObject(ToastManager())
}
