//
//  VoteView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI



struct VoteView: View {
    @StateObject private var viewModel = VoteViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(viewModel.items) { item in
                        HStack {
                            Text(item.name)
                                .font(.title2)
                            Spacer()
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                    .onMove(perform: viewModel.move)
                    
                }
            }
        }
    }
    
    
}

#Preview {
    VoteView()
}
