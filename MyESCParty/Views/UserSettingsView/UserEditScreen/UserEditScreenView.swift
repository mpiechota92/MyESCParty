//
//  UserEditScreenView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import SwiftUI

struct UserEditScreenView: View {
    @EnvironmentObject var imageManager: ImageManager
    
    @ObservedObject var viewModel: UserSettingsViewModel
    @State private var showNameChange: Bool = false
    @State private var showImageChange: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Group {
                    Image("cat")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, -5)
                    
                    Button() {
                        showImageChange.toggle()
                    } label: {
                        Text("Edit")
                            .foregroundStyle(.lightNavy)
                            .bold()
                    }
                    .padding(.bottom, 15)
                }
                .sheet(isPresented: $showImageChange) {
                    ImageChangeSheetView()
                        .presentationDetents([.fraction(0.25)])
                }
                
                List {
                    Section("Name") {
                        Button {
                            showNameChange.toggle()
                        } label: {
                            HStack {
                                Text(viewModel.userName)
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                    }
                }
                .scrollDisabled(true)
                .sheet(isPresented: $showNameChange) {
                    NameChangeSheetView(viewModel: viewModel, isPresented: $showNameChange)
                        .presentationDetents([.fraction(0.20)])
                }
            }
            
            if viewModel.loadingType == .fullScreen {
                FullScreenLoadingView()
            }
        }
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserEditScreenView(viewModel: UserSettingsViewModel(userID: "123"))
        .environmentObject(AuthViewModel())
}
