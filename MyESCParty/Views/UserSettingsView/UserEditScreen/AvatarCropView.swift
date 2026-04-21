//
//  AvatarCropView.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 19/04/2026.
//

import SwiftUI

struct AvatarCropView: View {
    private let cropDiameter: CGFloat = 300.0
    
    let image: UIImage
    let onSaveAction: (Data) -> Void
    
    @State private var initialScale: CGFloat = 0.0
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Image(uiImage: image)
                .scaleEffect(scale)
                .offset(offset)
            
            ZStack {
                Rectangle()
                    .fill(.black.opacity(0.6))
                
                Circle()
                    .frame(width: cropDiameter)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            .gesture (
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                let clampedScale = AvatarCropHelper.clampedScale(
                                    for: scale,
                                    initialScale: initialScale
                                )
                                commitScale(clampedScale)
                                
                                let clampedOffset = AvatarCropHelper.clampedOffset(
                                    for: offset,
                                    inImage: image.size,
                                    withScale: clampedScale,
                                    cropDiameter: cropDiameter
                                )
                                commitOffset(clampedOffset)
                            }
                        },
                    DragGesture()
                        .onChanged { value in
                            offset = AvatarCropHelper.computeNewOffset(
                                for: value.translation,
                                from: lastOffset
                            )
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                let proposedOffset = AvatarCropHelper.computeNewOffset(
                                    for: value.translation,
                                    from: lastOffset
                                )
                                let clampedOffset = AvatarCropHelper.clampedOffset(
                                    for: proposedOffset,
                                    inImage: image.size,
                                    withScale: scale,
                                    cropDiameter: cropDiameter
                                )
                                commitOffset(clampedOffset)
                            }
                        }
                )
            )
        }
        .safeAreaInset(edge: .bottom) {
            BaseButton(title: "Save") {
                if let imageData = AvatarCropHelper.getCroppedImageData(
                    image,
                    scale: scale,
                    offset: offset,
                    cropDiameter: cropDiameter
                ) {
                    onSaveAction(imageData)
                }
            }
            .frame(width: 200)
        }
        .ignoresSafeArea()
        .onAppear {
            let baseScale = AvatarCropHelper.computeInitialScale(for: image.size, cropDiameter: cropDiameter)
            setInitialScale(baseScale)
        }
    }
    
    private func setInitialScale(_ value: CGFloat) {
        initialScale = value
        commitScale(value)
    }
    
    private func commitScale(_ value: CGFloat) {
        scale = value
        lastScale = value
    }
    
    private func commitOffset(_ value: CGSize) {
        offset = value
        lastOffset = value
    }
}

#Preview {
    AvatarCropView(image: UIImage(named: "cat")!) { data in
        
    }
}
