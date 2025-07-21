//
//  RevealOverlayScrollObserver.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 21/07/2025.
//

import UIKit
import SwiftUI

class RevealOverlayScrollObserver: NSObject {
    private var observation: NSKeyValueObservation?
    private var previousOffset: CGFloat = 0
    private var threshold: CGFloat = 5
    @Binding var shouldRevealOverlay: Bool
    
    init(scrollView: UIScrollView, shouldRevealOverlay: Binding<Bool>) {
        self._shouldRevealOverlay = shouldRevealOverlay
        super.init()
        
        observation = scrollView.observe(\.contentOffset, options: [.new]) { [weak self] scrollView, change in
            guard let self = self else { return }
            
            let currentOffset = scrollView.contentOffset.y
            defer { self.previousOffset = currentOffset }
            
            if currentOffset < 0 || isScrollNearBottom(scrollView) {
                self.shouldRevealOverlay = true
                return
            }
            
            let delta = currentOffset - self.previousOffset
            
            if delta > self.threshold {
                self.shouldRevealOverlay = false
            } else if delta < -self.threshold {
                self.shouldRevealOverlay = true
            }
        }
    }
    
    private func isScrollNearBottom(_ scrollView: UIScrollView, threshold: CGFloat = 50) -> Bool {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height
        
        return (contentHeight - (contentOffsetY + visibleHeight)) < threshold
    }
}
