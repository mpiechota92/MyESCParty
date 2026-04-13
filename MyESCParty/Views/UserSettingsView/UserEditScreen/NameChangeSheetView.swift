//
//  NameChangeSheetView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import SwiftUI

struct NameChangeSheetView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var viewModel: UserSettingsViewModel
    @Binding var isPresented: Bool
    
    @State private var newName: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundStyle(.black)
                    
                    Text("Name")
                        .bold()
                        .frame(maxWidth: .infinity)
                    
                    Button("Save") {
                        Task {
                            try await viewModel.changeName(newName: newName)
                            
                            if viewModel.error != nil {
                                isPresented = false
                            }
                        }
                    }
                    .tint(.black)
                    .disabled(!isSaveActive())
                }
                .padding(.horizontal)
                
                TextField("New name", text: $newName)
                    .padding()
                
                Text("People will see this name in the voting rooms you are in.")
                    .foregroundStyle(.lightNavy)
                    .font(.caption)
                    .padding(.horizontal, 10)
                
                Spacer()
            }
            .padding()
            .onAppear {
                newName = viewModel.userName
            }
            
        }
    }
    
    private func isSaveActive() -> Bool {
        guard !newName.isEmpty else {
            return false
        }
        
        return newName != viewModel.userName
    }
}

#Preview {
    NameChangeSheetView(viewModel: UserSettingsViewModel(), isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}
