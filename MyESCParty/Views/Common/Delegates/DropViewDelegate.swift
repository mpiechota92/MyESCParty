//
//  DropViewDelegate.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 18/07/2025.
//

import SwiftUI

struct DropViewDelegate: DropDelegate {
    @Binding var topList: [Contestant]
    @Binding var bottomList: [Contestant]
    @Binding var draggedItem: Contestant?
    
    let contestant: Contestant
    
    let draggedFromTopList: Bool
    let droppedOnTopList: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem, draggedItem != contestant else { return }
        
        let sourceList = draggedFromTopList ? topList : bottomList
        let destinationList = droppedOnTopList ? topList : bottomList
        
        if let fromIndex = sourceList.firstIndex(of: draggedItem),
           let toIndex = destinationList.firstIndex(of: contestant),
           abs(fromIndex - toIndex) <= 1 {
            return
        }
        
        if draggedFromTopList {
            if let index = topList.firstIndex(of: draggedItem) {
                topList.remove(at: index)
            }
        } else {
            if let index = bottomList.firstIndex(of: draggedItem) {
                bottomList.remove(at: index)
            }
        }
        
        if let index = destinationList.firstIndex(of: contestant) {
            if droppedOnTopList {
                topList.insert(draggedItem, at: index)
            } else {
                bottomList.insert(draggedItem, at: index)
            }
        }
    }
}
