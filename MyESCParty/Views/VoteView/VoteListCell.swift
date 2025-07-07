//
//  VoteListCell.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import SwiftUI

struct VoteListCell: View {
    @State var data: String
    
    var body: some View {
        ZStack {
            HStack {
                Text(data)
                
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    VoteListCell(data: "Poland")
}

