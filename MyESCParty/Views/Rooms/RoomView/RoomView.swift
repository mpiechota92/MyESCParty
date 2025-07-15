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
    
    init(roomName: String, roomType: RoomType, roomId: Int) {
        self.roomName = roomName
        self.roomType = roomType
        _viewModel = .init(wrappedValue: .init(roomId: roomId))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(roomName)
                    .foregroundStyle(.black)
                    .font(.title)
                    .padding(.horizontal, 10)
                Image(systemName: roomType.rawValue)
                
                Spacer()
                
                Text("\(viewModel.userCount)")
                Image(systemName: "person.2.fill")
                    .padding(.trailing, 10)
            }
            
            Spacer()
        }
        .task {
            await viewModel.fetchUserCount()
        }
    }
}

#Preview {
    RoomView(roomName: "Global", roomType: .publicRoom, roomId: 1)
}
