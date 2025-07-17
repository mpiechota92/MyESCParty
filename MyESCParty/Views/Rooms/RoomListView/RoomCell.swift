//
//  RoomCell.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/06/2025.
//

import SwiftUI

struct RoomCell: View {
    
    @ObservedObject var viewModel: RoomListViewModel
    
    @State private var showDetails: Bool = false
    
    var room: Room
    var isUserInRoom: Bool
    var onTap: (() -> Void)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .stroke(.lightNavy, lineWidth: 1)
                .frame(maxWidth: .infinity, maxHeight: 100)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(room.name)")
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("\(room.userCount ?? 0)")
                    }
                }
                
                Spacer()
                
                if !isUserInRoom {
                    Button {
                        Task {
                            await viewModel.joinRoom(id: room.id)
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
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    RoomCell(viewModel: RoomListViewModel(),
             room: Room.publicRoomMock,
             isUserInRoom: false
    ) { }
}
