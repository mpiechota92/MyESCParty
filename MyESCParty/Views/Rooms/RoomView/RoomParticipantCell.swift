//
//  RoomParticipantCell.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 16/07/2025.
//

import SwiftUI

struct RoomParticipantCell: View {
    let roomParticipant: RoomParticipant
    
    var body: some View {
        HStack {
            Image("cat")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading, 10)
            Text(roomParticipant.username)
            Spacer()
            
            if let isAdmin = roomParticipant.isAdmin, isAdmin {
                Image(systemName: "person.badge.key.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 10)
            }
        }
        .padding(.bottom, 2)
    }
}

#Preview {
    RoomParticipantCell(roomParticipant: RoomParticipant(id: "18923798237187", roomId: 1, username: "Pjeszi", isAdmin: true))
}
