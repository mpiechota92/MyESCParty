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
                        
                        if viewModel.loadingType == .inline {
                            InLineLoadingView()
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                HStack {
                    BaseButton(title: "Join a room") {
                        
                    }
                    
                    BaseCircleButton(imageName: "plus") {
                        createRoomMode = true
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
