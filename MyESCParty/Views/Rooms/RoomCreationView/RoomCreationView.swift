//
//  RoomCreationView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import SwiftUI

struct RoomCreationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var toastManager: ToastManager
    @StateObject private var viewModel: RoomCreationViewModel
    
    @State private var roomName: String = ""
    @State private var isPrivate: Bool = false
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    
    init(viewModel: RoomCreationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Toggle("Private Room", isOn: $isPrivate)
                TextField("RoomName", text: $roomName)
                    .autocorrectionDisabled()
                
                if isPrivate {
                    SecureField("Password", text: $password)
                    SecureField("Repeat password", text: $repeatPassword)
                }
                
                if let error = viewModel.error {
                    ScrollView {
                        Text("\(error)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                
                Spacer()
                
                Button {
                    Task {
                        await viewModel.createRoom(name: roomName, password: password)
                        
                        if let error = viewModel.error {
                            toastManager.showToast(message: error.localizedDescription, type: .error)
                        } else {
                            dismiss()
                            toastManager.showToast(message: "Room was created", type: .success)
                        }
                    }
                } label: {
                    Text("Create room")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
            }
            .padding()
            
            if viewModel.loadingType == .fullScreen {
                FullScreenLoadingView()
            }
        }
    }
}

#Preview {
    RoomCreationView(viewModel: RoomCreationViewModel())
}
