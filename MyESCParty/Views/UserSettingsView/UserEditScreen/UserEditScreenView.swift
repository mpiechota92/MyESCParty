//
//  UserEditScreenView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import SwiftUI
import PhotosUI

struct UserEditScreenView: View {
    @EnvironmentObject var toastManager: ToastManager
    @EnvironmentObject var imageManager: ImageManager
    
    @ObservedObject var viewModel: UserSettingsViewModel
    @State private var showNameChangeSheet: Bool = false
    @State private var showImageChangeSheet: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showCropView: Bool = false
    @State private var image: UIImage = UIImage(named: "cat")!
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Group {
                    // TODO: separate view and add it to the Settings screen
                    switch viewModel.profilePictureState {
                    case .none:
                        Image("cat")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(.circle)
                            .padding(.top, -5)
                    case .loading:
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .padding(.top, -5)
                    case .failedLoading:
                        Image(systemName: "cross.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(.circle)
                            .padding(.top, -5)
                    case .loaded(let profileImage):
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(.circle)
                            .padding(.top, -5)
                    }
                    
                    Button() {
                        showImageChangeSheet.toggle()
                    } label: {
                        Text("Edit")
                            .foregroundStyle(.lightNavy)
                            .bold()
                    }
                    .padding(.bottom, 15)
                }
                .sheet(isPresented: $showImageChangeSheet) {
                    ImageChangeSheetView(isPresented: $showImageChangeSheet) { selectedItem in
                        Task {
                            try? await processImage(selectedItem)
                        }
                    }
                    .presentationDetents([.fraction(0.25)])
                }
                
                List {
                    Section("Name") {
                        Button {
                            showNameChangeSheet.toggle()
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
                .sheet(isPresented: $showNameChangeSheet) {
                    NameChangeSheetView(viewModel: viewModel, isPresented: $showNameChangeSheet)
                        .presentationDetents([.fraction(0.25)])
                }
            }
            
            if viewModel.loadingType == .fullScreen {
                FullScreenLoadingView()
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showCropView) {
            if let selectedImage {
                AvatarCropView(isPresented: $showCropView, image: selectedImage) { imageData in
                    Task {
                        do {
                            try await viewModel.changePicture(newPicture: imageData)
                            
                        } catch {
                            toastManager.showErrorToast(error: error)
                        }
                    }
                }
            }
        }
    }
    
    private func processImage(_ item: PhotosPickerItem) async throws {
        viewModel.loadingType = .fullScreen
        defer { viewModel.loadingType = .none }
        
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            selectedImage = image
            showCropView = true
        }
    }
}

#Preview {
    UserEditScreenView(viewModel: UserSettingsViewModel(userID: "123"))
        .environmentObject(AuthViewModel())
        .environmentObject(ToastManager())
}
