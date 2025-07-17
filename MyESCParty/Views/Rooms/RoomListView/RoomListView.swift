//
//  RoomListView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import SwiftUI

struct RoomListView: View {
    @StateObject private var viewModel: RoomListViewModel = .init()
    @State private var createRoomMode: Bool = false
    @State private var selectedRoom: Room?
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search", text: $viewModel.searchText)
                    .padding()
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.rooms) { room in
                            let isUserInRoom = viewModel.isUserInRoom(room.id)
                            RoomCell(
                                viewModel: viewModel,
                                room: room,
                                isUserInRoom: isUserInRoom,
                            ) {
                                selectedRoom = room
                            }
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
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.navy)
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                    
                    Button {
                        createRoomMode = true
                    } label: {
                        Circle()
                            .fill(.navy)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                            )
                    }
                }
                .padding([.horizontal, .bottom], 20)
                
            }
            .navigationTitle("Voting Rooms")
            .task {
                await viewModel.fetchRooms()
            }
            .navigationDestination(isPresented: $createRoomMode) {
                RoomCreationView()
            }
            .navigationDestination(item: $selectedRoom) { room in
                RoomView(
                    roomName: room.name,
                    roomType: room.roomType,
                    roomId: room.id
                )
            }
        }
    }
}

#Preview {
    RoomListView()
}
