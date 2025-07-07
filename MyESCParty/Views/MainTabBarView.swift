//
//  MainTabBarView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

struct MainTabBarView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink {
                        Text("Asd")
                    } label: {
                        Image(systemName: "person.circle")
                            .foregroundStyle(.black)
                            .padding()
                    }
                }
                TabView {
                    RoomListView()
                        .navigationTitle("Voting Rooms")
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
            }
        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItemGroup(placement: .topBarTrailing) {
//                NavigationLink {
//                    Text("Asd")
//                } label: {
//                    Image(systemName: "person.circle")
//                        .foregroundStyle(.black)
//                }
//            }
//        }
    }
}

#Preview {
    MainTabBarView()
}
