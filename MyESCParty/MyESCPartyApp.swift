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
        let env = AppEnvironment()
        _env = StateObject(wrappedValue: env)
        _authViewModel = StateObject(wrappedValue: AuthViewModel(authManager: env.resolve()))
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(env)
                
                ToastHostView()
            }
            .environmentObject(toastManager)
        }
    }
}
