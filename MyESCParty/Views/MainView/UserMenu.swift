//
//  UserMenu.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import SwiftUI

struct UserMenu: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                Task {
                    await authViewModel.signOut()
                }
            }
            
        } label: {
            Image(systemName: "person.circle")
                .font(.system(size: 32))
                .foregroundStyle(.navy)
                .padding()
            
        }
    }
}

#Preview {
    UserMenu()
}
