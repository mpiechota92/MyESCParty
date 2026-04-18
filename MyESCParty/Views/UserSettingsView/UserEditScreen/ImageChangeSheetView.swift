//
//  ImageChangeSheetView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 13/04/2026.
//

import SwiftUI

struct ImageChangeSheetView: View {
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
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Choose photo")
                        Spacer()
                        Image(systemName: "photo")
                    }
                }
            }
            
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    ImageChangeSheetView()
}
