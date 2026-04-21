//
//  AvatarCropHelper.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 21/04/2026.
//

import UIKit

enum AvatarCropHelper {
    static func clampedOffset(
        for proposedOffset: CGSize,
        inImage image: CGSize,
        withScale scale: CGFloat,
        cropDiameter: CGFloat
    ) -> CGSize {
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
    
    static func getCroppedImageData(
        _ image: UIImage,
        scale: CGFloat,
        offset: CGSize,
        cropDiameter: CGFloat
    ) -> Data? {
        let cropSizeInImage = cropDiameter / scale
        
        let cropRect = CGRect(
            x: ((image.size.width - cropSizeInImage) / 2) - (offset.width / scale),
            y: ((image.size.height - cropSizeInImage) / 2) - (offset.height / scale),
            width: cropSizeInImage,
            height: cropSizeInImage
        ).integral
        
        guard let croppedCGImage = image.cgImage?.cropping(to: cropRect) else { return nil }
        
        let croppedImage = UIImage(
            cgImage: croppedCGImage,
            scale: image.scale,
            orientation: image.imageOrientation
        )
        
        let resized = resizedImage(croppedImage, to: CGSize(width: 256, height: 256))
        return resized.jpegData(compressionQuality: 0.9)
    }
    
    private static func resizedImage(_ image: UIImage, to targetSize: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
    }
}
