//
//  UserSettingsView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/04/2026.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showLogout: Bool = false
    var body: some View {
        NavigationStack {
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
                
                Text("Maciej")
                    .font(.largeTitle)
                
                List {
                    Section {
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
                    
                    Section {
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
    UserSettingsView()
        .environmentObject(AuthViewModel())
}
