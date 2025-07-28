//
//  UserMenu.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import SwiftUI

struct UserMenu: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var parentViewModel: BaseViewModel
    
    @StateObject private var viewModel: UserMenuViewModel = UserMenuViewModel()
    @State private var showAlert = false
    
    var body: some View {
        Menu {
            Button("Profile") {
                print("wybrano 1")
            }
            
            Button("Settings") {
                print("wybrano 1")
            }
            
            Button("About") {
                print("wybrano 1")
            }
            
            Divider()
            
            Button("Logout") {
                showAlert = true
            }
            
        } label: {
            Image(systemName: "person.circle")
                .font(.system(size: 32))
                .foregroundStyle(.navy)
                .padding()
            
        }
        .confirmationDialog("Do you want to logout?", isPresented: $showAlert) {
            Button("Log out", role: .destructive) {
                Task {
                    await viewModel.signOut(authViewModel: authViewModel)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .tint(.lightNavy)
        .onReceive(viewModel.$error) { error in
            Task { @MainActor in
                parentViewModel.error = error
            }
        }
    }
}

#Preview {
    UserMenu(parentViewModel: BaseViewModel())
}
