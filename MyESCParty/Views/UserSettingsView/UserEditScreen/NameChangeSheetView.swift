//
//  NameChangeSheetView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import SwiftUI

struct NameChangeSheetView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var toastManager: ToastManager
    
    @ObservedObject var viewModel: UserSettingsViewModel
    @Binding var isPresented: Bool
    let oldName: String
    
    @State private var newName: String = ""
    
    var body: some View {
        ScrollView {
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
                        
                        if let error = viewModel.error {
                            toastManager.showErrorToast(error: error)
                        } else {
                            isPresented = false
                            toastManager.showToast(message: "Name change successful!", type: .success)
                        }
                    }
                }
                .tint(.black)
                .disabled(!isSaveActive())
            }
            .padding([.top, .horizontal])
            
            BaseTextField("New name", text: $newName)
                .padding()
            
            Text("People will see this name in the voting rooms you are in.")
                .foregroundStyle(.lightNavy)
                .font(.caption)
                .padding(.horizontal, 10)
            
        }
        .padding()
        .onAppear {
            newName = viewModel.userProfile?.username ?? ""
        }
        .scrollDisabled(true)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func isSaveActive() -> Bool {
        guard !newName.isEmpty else {
            return false
        }
        
        return newName != oldName
    }
}

#Preview {
    NameChangeSheetView(viewModel: UserSettingsViewModel(userID: "123"), isPresented: .constant(true), oldName: "Maciej")
        .environmentObject(AuthViewModel())
}
