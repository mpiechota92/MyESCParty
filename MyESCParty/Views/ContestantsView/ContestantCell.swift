//
//  ContestantCell.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import SwiftUI

struct ContestantCell: View {
    var contestant: Contestant
    
    let imageUrl: URL = URL(string: "https://picsum.photos/200")!
    @State private var showDetails = false
    
    var body: some View {
        ZStack {
            HStack {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 75, height: 75)
                    case .failure(_):
                        Image(systemName: "questionmark")
                            .font(.headline)
                    @unknown default:
                        Image(systemName: "questionmark")
                            .font(.headline)
                        
                    }
                }
                .frame(width: 75, height: 75)
                .background(.red)
                
                VStack(alignment: .leading) {
                    Text(contestant.country)
                        .font(.headline)
                    Text(contestant.artist ?? "")
                        .font(.caption)
                        .bold()
                    Text(contestant.song ?? "")
                        .font(.caption)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .padding()
            }
            
            Image(contestant.country)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 60)
        }
        .onTapGesture {
            showDetails = true
        }
        .background {
            NavigationLink(destination: Text("Kupa"), isActive: $showDetails) {
                EmptyView()
            }
            .hidden()
        }
        
        
    }
}

#Preview {
//    ContestantCell(contestant: )
}
