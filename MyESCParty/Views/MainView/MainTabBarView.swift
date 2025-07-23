//
//  MainTabBarView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

struct MainTabBarView: View {
    @EnvironmentObject var toastManager: ToastManager
    @StateObject private var viewModel: MainTabBarViewModel = MainTabBarViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                UserMenu(parentViewModel: viewModel)
            }
            TabView {
                RoomListView()
                    .tabItem {
                        Image(systemName: "person.crop.rectangle.stack")
                        Text("Voting rooms")
                    }
                
                ContestantsView()
                    .tabItem {
                        Image(systemName: "flag")
                        Text("Contestants")
                    }
                
                VoteView()
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
    }
}

#Preview {
    MainTabBarView()
        .environmentObject(ToastManager())
}
