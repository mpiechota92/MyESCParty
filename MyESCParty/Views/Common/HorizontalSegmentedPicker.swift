//
//  HorizontalSegmentedPicker.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 28/07/2025.
//

import SwiftUI

protocol SegmentedPickerElement:
    CaseIterable,
    Identifiable,
    RawRepresentable,
    Equatable,
    Hashable
where RawValue == String { }

extension SegmentedPickerElement {
    var id: String { rawValue }
}

struct HorizontalSegmentedPicker<Item: SegmentedPickerElement>: View {
    
    let items: [Item]
    @Binding var selectedItem: Item
    let onSelect: (Item) -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items) { item in
                        segmentButton(for: item)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .onChange(of: selectedItem) { _, newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
    @ViewBuilder
    private func segmentButton(for item: Item) -> some View {
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

#Preview {
    StatefulPreviewWrapper(ContestantsGroup.all) { selection in
        HorizontalSegmentedPicker(
            items: ContestantsGroup.allCases,
            selectedItem: selection) { item in
            
        }
    }
}
