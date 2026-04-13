//
//  MyESCPartyApp.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

@main
struct MyESCPartyApp: App {
    @StateObject private var toastManager = ToastManager()
    @StateObject private var env: AppEnvironment
    @StateObject private var authViewModel: AuthViewModel
    
    init() {
        let env = AppEnvironment.shared
        _env = StateObject(wrappedValue: env)
        _authViewModel = StateObject(wrappedValue: AuthViewModel(authManager: env.resolve()))
        
        UIRefreshControl.appearance().tintColor = .navy
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()
                    .environmentObject(authViewModel)
                    .environmentObject(env)
                
                ToastHostView()
            }
            .environmentObject(toastManager)
        }
    }
}
