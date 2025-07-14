//
//  RoomCell.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import SwiftUI

struct RoomCell: View {
    
    @ObservedObject var viewModel: RoomListViewModel
    
    var roomName: String
    var roomId: Int
    var participants: Int
    var isUserInRoom: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
                .stroke(.lightNavy, lineWidth: 1)
                .frame(maxWidth: .infinity, maxHeight: 100)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(roomName)")
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("\(participants)")
                    }
                }
                
                Spacer()
                
                if !isUserInRoom {
                    Button {
                        Task {
                            await viewModel.joinRoom(id: roomId)
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height: 50)
                            .foregroundStyle(.navy)
                            .overlay(
                                Text("Join")
                                    .foregroundStyle(.white)
                            )
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    RoomCell(viewModel: RoomListViewModel(), roomName: "Pokój 1", roomId: 1, participants: 10, isUserInRoom: true)
}
