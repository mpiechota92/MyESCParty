//
//  HorizontalSegmentedPicker.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 28/07/2025.
//

import SwiftUI

struct HorizontalSegmentedPicker<Item>: View
where Item: Hashable & Identifiable & RawRepresentable, Item.RawValue == String {
    
    let items: [Item]
    @Binding var selectedItem: Item
    let onSelect: (Item) -> Void
    
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items) { item in
                        let isSelected = selectedItem == item
                        
                        Button {
                            selectedItem = item
                            onSelect(item)
                        } label: {
                            Text(item.rawValue)
                                .id(item)
                                .font(.title2.bold())
                                .padding(.vertical, 5)
                                .padding(.horizontal, 5)
                                .foregroundStyle(isSelected ? .white : .black)
                        }
                        .background {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.lightNavy)
                            }
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .onChange(of: selectedItem) { oldValue, newValue in
                if oldValue != newValue {
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper(ContestantsGroup.all) { selection in
        HorizontalSegmentedPicker(
            items: ContestantsGroup.allCases,
            selectedItem: selection) { item in
            
        }
    }
}
