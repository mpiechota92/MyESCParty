//
//  RoomListView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import SwiftUI

struct RoomListView: View {
    @EnvironmentObject var env: AppEnvironment
    @EnvironmentObject var toastManager: ToastManager
    
    @StateObject private var viewModel: RoomListViewModel
    @State private var createRoomMode: Bool = false
    @State private var selectedRoom: Room?
    
    @State private var searchText: String = ""
    
    // TODO: Why inject viewModel?
    init(viewModel: RoomListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .tint(.black)
                
                ScrollView {
                    LazyVStack {
                        if viewModel.loadingType == .inline {
                            ProgressView()
                        }
                        
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
                    }
                    .padding(.vertical, 10)
                }
                .refreshableTask {
                    await viewModel.fetchRooms(forceRefresh: true)
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
            .onChange(of: searchText) {
                viewModel.searchText = searchText
            }
            .navigationTitle("Voting Rooms")
            .navigationDestination(isPresented: $createRoomMode) {
                RoomCreationView(viewModel:
                                    RoomCreationViewModel(
                                        roomCreationService: env.resolve(),
                                        roomService: env.resolve()
                                    )
                )
            }
            .navigationDestination(item: $selectedRoom) { room in
                RoomView(
                    viewModel: RoomViewModel(service: env.resolve(), roomId: room.id),
                    roomName: room.name,
                    roomType: room.roomType
                )
            }
        }
        .task {
            await viewModel.fetchRooms(loadingType: .inline)
        }
        .onReceive(viewModel.$error) { error in
            guard let error else { return }
            toastManager.showErrorToast(error: error)
        }
    }
}

#Preview {
    RoomListView(viewModel: RoomListViewModel())
        .environmentObject(AppEnvironment())
        .environmentObject(ToastManager())
}
