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
    @StateObject private var viewModel: MainTabBarViewModel = MainTabBarViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                UserMenu(parentViewModel: viewModel)
            }
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
            }
            .tint(.navy)
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
        .environmentObject(ToastManager())
        .environmentObject(AppEnvironment.shared)
}
