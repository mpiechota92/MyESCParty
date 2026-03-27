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
            
            TextField("Email", text: $viewModel.email)
                .frame(width: 200)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.bottom)
                .onSubmit {
                    DispatchQueue.main.async {
                        focusedField = viewModel.authType == .signUp ? .username : .password
                    }
                }
            
            if viewModel.authType == .signUp {
                TextField("username", text: $viewModel.username)
                    .frame(width: 200)
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .keyboardType(.default)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.bottom)
                    .onSubmit {
                        DispatchQueue.main.async {
                            focusedField = .password
                        }
                    }
            }
            
            SecureField("Password", text: $viewModel.password)
                .frame(width: 200)
                .textContentType(viewModel.authType == .signIn ? .password : .newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(viewModel.authType == .signUp ? .next : .done)
                .padding(.bottom)
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
            
            if viewModel.authType == .signUp {
                SecureField("Repeat password", text: $viewModel.repeatPassword)
                    .frame(width: 200)
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .repeatPassword)
                    .onSubmit {
                        Task {
                            await viewModel.submit(authViewModel: authViewModel)
                        }
                    }
            }
        }
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
