//
//  AvatarCropHelper.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 21/04/2026.
//

import Foundation

enum AvatarCropHelper {
    static func clampedOffset(for proposedOffset: CGSize,
                              inImage image: CGSize,
                              withScale scale: CGFloat,
                              cropDiameter: CGFloat) -> CGSize {
        
        let halfDisplayedWidth = (image.width * scale) / 2
        let halfDisplayedHeight = (image.height * scale) / 2
        
        let maxOffsetX = max(0, halfDisplayedWidth - (cropDiameter / 2))
        let maxOffsetY = max(0, halfDisplayedHeight - (cropDiameter / 2))
        
        let finalX = min(max(proposedOffset.width, -maxOffsetX), maxOffsetX)
        let finalY = min(max(proposedOffset.height, -maxOffsetY), maxOffsetY)
        
        return CGSize(width: finalX, height: finalY)
    }
    
    static func clampedScale(for proposedScale: CGFloat, initialScale: CGFloat) -> CGFloat {
        if proposedScale < initialScale {
            return initialScale
            
        } else if proposedScale > (3.0 * initialScale) {
            return 3.0 * initialScale
        }
        
        return proposedScale
    }
    
    static func computeInitialScale(for image: CGSize, cropDiameter: CGFloat) -> CGFloat {
        let scaleX = cropDiameter / image.width
        let scaleY = cropDiameter / image.height
        return max(scaleX, scaleY)
    }
    
    static func computeNewOffset(for translation: CGSize, from lastOffset: CGSize) -> CGSize {
        return CGSize(
                width: translation.width + lastOffset.width,
                height: translation.height + lastOffset.height
            )
    }
}
