//
//  ProfilePictureView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 24/04/2026.
//

import SwiftUI

struct ProfilePictureView: View {
    @Binding var profilePictureState: ProfilePictureState
    
    var body: some View {
        switch profilePictureState {
        case .none:
            Image("cat")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(.circle)
                .padding(.top, -5)
        case .loading:
            ProgressView()
                .frame(width: 150, height: 150)
                .padding(.top, -5)
        case .failedLoading:
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(.circle)
                .padding(.top, -5)
                .foregroundStyle(.red)
        case .loaded(let profileImage):
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(.circle)
                .padding(.top, -5)
        }
    }
}

#Preview {
    ProfilePictureView(profilePictureState: .constant(.loading))
    ProfilePictureView(profilePictureState: .constant(.failedLoading))
    ProfilePictureView(profilePictureState: .constant(.none))
    ProfilePictureView(profilePictureState: .constant(.loaded(UIImage(named: "cat")!)))
}
