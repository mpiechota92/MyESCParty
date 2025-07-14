//
//  MyESCPartyApp.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

@main
struct MyESCPartyApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var toastManager = ToastManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(authViewModel)
                
                ToastHostView()
            }
            .environmentObject(toastManager)
        }
    }
}
