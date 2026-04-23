//
//  UserSettingsView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/04/2026.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var imageManager: ImageManager
    @EnvironmentObject var toastManager: ToastManager
    
    @StateObject private var viewModel: UserSettingsViewModel
    
    @State private var showLogout: Bool = false
    @State private var showUserEditScreen: Bool = false
    
    init(viewModel: UserSettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Image("cat")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, 50)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "camera")
                        }
                    
                    Text(viewModel.userName)
                        .font(.largeTitle)
                }
                .onTapGesture {
                    showUserEditScreen.toggle()
                }
                
                List {
                    Section("Account") {
                        NavigationLink {
                            Text("Privacy")
                        } label: {
                            Label("Voting privacy", systemImage: "lock")
                        }
                        
                        NavigationLink {
                            Text("Account")
                        } label: {
                            Label("Account", systemImage: "key")
                        }
                    }
                    
                    Section("App") {
                        NavigationLink {
                            Text("Settings")
                        } label: {
                            Label("Feedback", systemImage: "questionmark.circle")
                        }
                        
                        NavigationLink {
                            Text("About")
                        } label: {
                            Label("About", systemImage: "info.circle")
                        }
                        
                        NavigationLink {
                            Text("Credits")
                        } label: {
                            Label("Image credits", systemImage: "list.clipboard")
                        }
                    }
                    
                    Section {
                        Button {
                            showLogout.toggle()
                        } label: {
                            Text("Log out")
                                .bold()
                                .foregroundStyle(.red)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                }
                .scrollDisabled(true)
                .tint(.black)
            }
            .navigationTitle("User Settings")
            .toolbar(.hidden)
            .navigationDestination(isPresented: $showUserEditScreen) {
                UserEditScreenView(viewModel: viewModel)
            }
        }
        .task {
            do {
                try await viewModel.fetchUserData()
            } catch {
                toastManager.showErrorToast(error: error)
            }
        }
        .sheet(isPresented: $showLogout) {
            // TODO: Separate View
            VStack(spacing: 10) {
                Text("Are you sure you want to logout?")
                Button("Yes", role: .destructive) {
                    showLogout.toggle()
                }
                Button("No") {
                    showLogout.toggle()
                }
            }
            .presentationDetents([.fraction(0.20)])
        }
    }
}

#Preview {
    UserSettingsView(viewModel: UserSettingsViewModel(userID: "123"))
        .environmentObject(ImageManager())
        .environmentObject(ToastManager())
        .environmentObject(AuthViewModel())
}
