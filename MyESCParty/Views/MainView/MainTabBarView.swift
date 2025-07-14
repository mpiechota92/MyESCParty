//
//  MainTabBarView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

struct MainTabBarView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                UserMenu()
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
    }
}

#Preview {
    MainTabBarView()
}
