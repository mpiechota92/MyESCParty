//
//  ContestantCell.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 09/07/2025.
//

import SwiftUI

struct ContestantCell: View {
    var contestant: Contestant
    
    @State private var showDetails = false
    
    var body: some View {
        ContestantView(contestant: contestant, cellType: .details)
        .onTapGesture {
            showDetails = true
        }
        .navigationDestination(isPresented: $showDetails) {
            Text("Kupa")
        }
        
        
    }
}

#Preview {
    ContestantCell(contestant: .mock)
}
