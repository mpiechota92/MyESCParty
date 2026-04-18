//
//  LoginFieldsView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 03/01/2026.
//

import SwiftUI

struct LoginFieldsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var viewModel: LoginViewModel
    
    @FocusState private var focusedField: LoginViewField?
    
    var body: some View {
        VStack(alignment: .center) {
            if let error = authViewModel.error {
                Text(error.localizedDescription)
            }
            
            BaseTextField("Email", text: $viewModel.email)
                .onSubmit {
                    DispatchQueue.main.async {
                        focusedField = viewModel.authType == .signUp ? .username : .password
                    }
                }
                .emailFieldStyle()
                .frame(width: 200)
                .focused($focusedField, equals: .email)
                .padding(.bottom)
            
            if viewModel.authType == .signUp {
                BaseTextField("username", text: $viewModel.username)
                    .submitLabel(.next)
                    .textContentType(.username)
                    .frame(width: 200)
                    .focused($focusedField, equals: .username)
                    .padding(.bottom)
                    .onSubmit {
                        DispatchQueue.main.async {
                            focusedField = .password
                        }
                    }
            }
            
            BaseSecureField("Password", text: $viewModel.password)
                .textContentType(viewModel.authType == .signIn ? .password : .newPassword)
                .submitLabel(viewModel.authType == .signUp ? .next : .done)
                .onSubmit {
                    if viewModel.authType == .signUp {
                        DispatchQueue.main.async {
                            focusedField = .repeatPassword
                        }
                    } else {
                        Task {
                            await viewModel.submit(authViewModel: authViewModel)
                        }
                    }
                }
                .frame(width: 200)
                .focused($focusedField, equals: .password)
                .padding(.bottom)
            
            if viewModel.authType == .signUp {
                BaseSecureField("Repeat password", text: $viewModel.repeatPassword)
                    .textContentType(.newPassword)
                    .onSubmit {
                        Task {
                            await viewModel.submit(authViewModel: authViewModel)
                        }
                    }
                    .frame(width: 200)
                    .focused($focusedField, equals: .repeatPassword)
            }
        }
        .tint(.black)
        .onChange(of: viewModel.authType) {
            focusedField = nil
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    LoginFieldsView(viewModel: LoginViewModel())
        .environmentObject(AuthViewModel())
}
