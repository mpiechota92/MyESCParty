//
//  ImageChangeSheetView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import SwiftUI
import PhotosUI

struct ImageChangeSheetView: View {
    @Binding var isPresented: Bool
    let onPhotoPicked: (PhotosPickerItem) -> Void
    
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Edit profile picture")
                .bold()
                .padding(.top, 15)
            
            List {
                Button {
                    
                } label: {
                    HStack {
                        Text("Take photo")
                        Spacer()
                        Image(systemName: "camera")
                    }
                }
                
                HStack {
                    PhotosPicker("Choose image", selection: $avatarPhotoItem, matching: .images)
                    Spacer()
                    Image(systemName: "photo")
                }
                
            }
        }
        .foregroundStyle(.black)
        .onChange(of: avatarPhotoItem) { _, newItem in
            guard let newItem else { return }
            onPhotoPicked(newItem)
            isPresented = false
        }
        
    }
}

#Preview {
    ImageChangeSheetView(isPresented: .constant(true)) { _ in
    }
}
