//
//  ContentView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/06/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isSessionActive {
            MainTabBarView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
