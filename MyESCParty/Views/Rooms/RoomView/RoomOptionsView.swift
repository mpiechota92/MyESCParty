//
//  RoomOptionsView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 17/07/2025.
//

import SwiftUI

struct RoomOptionsView: View {
    @ObservedObject var viewModel: RoomViewModel
    
    var body: some View {
        Menu {
            if !viewModel.isAdmin {
                Button {
                    viewModel.leave
                } label: {
                    Text("Leave room")
                }
            } else {
                Button(role: .destructive) {
                    
                } label: {
                    Text("Delete room")
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .foregroundStyle(.black)
                .padding()
        }
        .onAppear {
            print(viewModel.isAdmin)
        }
    }
}

#Preview {
    RoomOptionsView(viewModel: RoomViewModel(roomId: 1))
}
