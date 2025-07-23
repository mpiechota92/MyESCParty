//
//  ContestantView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 11/07/2025.
//

import SwiftUI

enum ContestantViewCellType: String {
    case details = "chevron.right"
    case dragAndDrop = "line.3.horizontal"
    case none = ""
}

struct ContestantView: View {
    var contestant: Contestant
    let cellType: ContestantViewCellType
    let imageUrl: URL = URL(string: "https://picsum.photos/200")!
    
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
                
                Image(systemName: cellType.rawValue)
                    .padding()
            }
            .background(.white)
            
            Image(contestant.country)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 60)
        }
    }
}

#Preview {
    ContestantView(contestant: .mockSweeden, cellType: .details)
}
