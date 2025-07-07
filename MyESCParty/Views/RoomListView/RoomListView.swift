//
//  RoomListView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import SwiftUI

struct RoomListView: View {
    @StateObject private var viewModel: RoomListViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $viewModel.searchText)
                    .padding()
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.rooms) { room in
                            let isUserInRoom = viewModel.isUserInRoom(room.id)
                            RoomCell(roomName: room.name, roomId: room.id, participants: room.userCount, isUserInRoom: isUserInRoom)
                                .padding(.horizontal, 10)
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("Join a Room")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.navy)
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                    
                    Button {
                        
                    } label: {
                        Circle()
                            .fill(.navy)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text("+")
                                    .font(.title)
                            )
                    }
                }
                .padding([.horizontal, .bottom], 20)
                
            }
            .navigationTitle("Voting Rooms")
        }
        .task {
            await viewModel.fetchRooms()
        }
    }
}

#Preview {
    RoomListView()
}
