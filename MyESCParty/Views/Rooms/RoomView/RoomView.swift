//
//  RoomView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import SwiftUI

struct RoomView: View {
    @EnvironmentObject var env: AppEnvironment
    @StateObject private var viewModel: RoomViewModel
    
    var roomName: String
    var roomType: RoomType
    
    @State private var userIsAdmin: Bool = false
    @State private var showResults: Bool = false
    
    init(viewModel: RoomViewModel, roomName: String, roomType: RoomType) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.roomName = roomName
        self.roomType = roomType
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(roomName)
                            .foregroundStyle(.black)
                            .font(.title)
                            .padding(.horizontal, 10)
                        Image(systemName: roomType.rawValue)
                        
                        Spacer()
                        
                        RoomOptionsView(viewModel: viewModel)
                    }
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .padding(.leading, 10)
                        Text("\(viewModel.users.count)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.users) { user in
                            HStack {
                                RoomParticipantCell(roomParticipant: user)
                            }
                        }
                    }
                }
                .refreshableTask {
                    await viewModel.fetchUsers(forceRefresh: true)
                }
                .safeAreaInset(edge: .bottom) {
                    BaseButton(title: "Show results") {
                        showResults = true
                    }
                    .padding(20)
                    .shadow(radius: 8)
                }
            }
            
            if viewModel.loadingType == .fullScreen {
                FullScreenLoadingView()
            }
        }
        .navigationDestination(isPresented: $showResults) {
            ResultsView(roomId: viewModel.roomId)
        }
        .task {
            await viewModel.fetchUsers()
        }
    }
}

#Preview {
    RoomView(viewModel: RoomViewModel(roomId: 1), roomName: "Global", roomType: .publicRoom)
        .environmentObject(AppEnvironment.shared)
}
