//
//  LoginView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

enum Field: Hashable {
    case email, password, repeatPassword, username
}

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    
    @State private var isUsernameValid: Bool = true
    @State private var isEmailValid: Bool = true
    @State private var isPasswordEmpty: Bool = false
    @State private var isRepeatPasswordEmpty: Bool = false
    @State private var isPasswordsMatch: Bool = true
    
    @State private var showCreateUser = false
    
    @FocusState private var focusedField: Field?
    
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
                        
                        TextField("Email", text: $email)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundStyle(isEmailValid ? .black : .red)
                            .padding()
                            .onSubmit {
                                focusedField = showCreateUser ? .username : .password
                            }
                        
                        if showCreateUser {
                            TextField("username", text: $username)
                                .focused($focusedField, equals: .username)
                                .submitLabel(.next)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .foregroundStyle(isUsernameValid ? .black : .red)
                                .padding()
                                .onSubmit {
                                    focusedField = .password
                                }
                        }
                        
                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(showCreateUser ? .next : .done)
                            .foregroundStyle(isPasswordEmpty ? .red : .black)
                            .padding()
                            .onSubmit {
                                if showCreateUser {
                                    focusedField = .repeatPassword
                                } else {
                                    Task {
                                        await signIn()
                                    }
                                }
                            }
                        
                        if showCreateUser {
                            SecureField("Repeat password", text: $repeatPassword)
                                .focused($focusedField, equals: .repeatPassword)
                                .foregroundStyle(isPasswordEmpty ? .red : .black)
                                .padding()
                                .onSubmit {
                                    Task {
                                        await signUp()
                                    }
                                }
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        if showCreateUser {
                            Button("Sign up") {
                                Task {
                                    await signUp()
                                }
                            }
                            .foregroundStyle(.black)
                            .padding()
                            Button("Already have an account") {
                                showCreateUser = false
                            }
                            .foregroundStyle(.red)
                        } else {
                            Button("Sign in") {
                                Task {
                                    await signIn()
                                }
                            }
                            .foregroundStyle(.black)
                            .padding()
                            Button("Create new user") {
                                showCreateUser = true
                            }
                            .foregroundStyle(.red)
                        }
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.3)
                    
                }
                
                if authViewModel.loadingType == .fullScreen {
                    FullScreenLoadingView()
                }
            }
        }
    }
    
    // TODO: move to viewModel + add validators
    
    func signIn() async {
        guard email.isEmailValid() && !email.isEmpty else {
            isEmailValid = email.isEmailValid()
            isPasswordEmpty = password.isEmpty
            return
        }
        
        isEmailValid = true
        isPasswordEmpty = false
        
        await authViewModel.signIn(email: email, password: password)
    }
    
    func signUp() async {
        guard email.isEmailValid(), !email.isEmpty, !password.isEmpty, !repeatPassword.isEmpty, !username.isEmpty else {
            isEmailValid = email.isEmailValid()
            isPasswordEmpty = password.isEmpty
            isRepeatPasswordEmpty = repeatPassword.isEmpty
            isUsernameValid = !username.isEmpty
            return
        }
        
        isEmailValid = true
        isPasswordEmpty = false
        isRepeatPasswordEmpty = false
        
        guard password == repeatPassword else {
            isPasswordsMatch = false
            return
        }
        
        isPasswordsMatch = true
        
        await authViewModel.signUp(email: email, username: username, password: password)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
