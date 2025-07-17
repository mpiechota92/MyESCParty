//
//  RoomView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 15/07/2025.
//

import SwiftUI

struct RoomView: View {
    @StateObject private var viewModel: RoomViewModel
    
    var roomName: String
    var roomType: RoomType
    
    @State private var userIsAdmin: Bool = false
    
    init(roomName: String, roomType: RoomType, roomId: Int) {
        self.roomName = roomName
        self.roomType = roomType
        _viewModel = .init(wrappedValue: .init(roomId: roomId))
    }
    
    var body: some View {
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
        }
        .task {
            await viewModel.fetchUsers(forceRefresh: true)
        }
    }
}

#Preview {
    RoomView(roomName: "Global", roomType: .publicRoom, roomId: 1)
}
