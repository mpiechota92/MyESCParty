//
//  MainTabBarView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

struct MainTabBarView: View {
    @EnvironmentObject var env: AppEnvironment
    @EnvironmentObject var toastManager: ToastManager
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject private var viewModel: MainTabBarViewModel = MainTabBarViewModel()
    
    var body: some View {
        VStack {
            TabView {
                RoomListView(viewModel: RoomListViewModel(service: env.resolve()))
                    .tabItem {
                        Image(systemName: "person.crop.rectangle.stack")
                        Text("Voting rooms")
                    }
                
                ContestantsView(viewModel: ContestantsViewModel(service: env.resolve()))
                    .tabItem {
                        Image(systemName: "flag")
                        Text("Contestants")
                    }
                
                VoteView(viewModel: VoteViewModel(service: env.resolve(), voteManager: env.resolve()))
                    .tabItem {
                        Image(systemName: "pencil")
                        Text("Vote")
                    }
                
                UserSettingsView(viewModel: UserSettingsViewModel(service: env.resolve()))
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("You")
                    }
                
            }
            .tint(.lightNavy)
        }
        .onReceive(viewModel.$error) { error in
            guard let error else { return }
            toastManager.showErrorToast(error: error)
        }
        .environmentObject(ImageManager(service: env.resolve()))
    }
}

#Preview {
    MainTabBarView()
        .environmentObject(AuthViewModel())
        .environmentObject(ToastManager())
        .environmentObject(AppEnvironment.shared)
}
