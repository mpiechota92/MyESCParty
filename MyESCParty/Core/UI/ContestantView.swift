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
    @EnvironmentObject private var imageManager: ImageManager
    @EnvironmentObject private var toastManager: ToastManager
    
    var contestant: Contestant
    let cellType: ContestantViewCellType
    let size: Double
    
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            HStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: size, height: size)
                } else {
                    ProgressView()
                        .tint(.navy)
                        .frame(width: size, height: size)
                        .task {
                            do {
                                // TODO: change after updating images in db
                                let imageUrl = "https://picsum.photos/seed/\(contestant.id)/200"
                                image = try await imageManager.image(for: imageUrl)
                            } catch {
                                toastManager.showToast(message: error.localizedDescription, type: .error)
                            }
                        }
                }
                
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
                
                if cellType != .none {
                    Image(systemName: cellType.rawValue)
                        .padding()
                }
            }
            .background(.white)
            
            Image(contestant.country)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, (size - 15))
        }
    }
}

#Preview {
    ContestantView(contestant: .mockSweeden, cellType: .details, size: 100)
        .environmentObject(ImageManager())
        .environmentObject(ToastManager())
}
