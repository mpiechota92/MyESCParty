//
//  ToastManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 14/07/2025.
//

import Foundation
import SwiftUI

enum ToastType {
    case info
    case error
    case success
}

struct Toast: Equatable {
    let message: String
    let type: ToastType
    let duration: Int = 5
}

class ToastManager: ObservableObject {
    @Published var currentToast: Toast?
    var currentWorkItem: DispatchWorkItem?
    
    func showToast(message: String, type: ToastType) {
        let toast = Toast(message: message, type: type)
        displayToast(toast)
    }
    
    func showErrorToast(error: any Error) {
        #if DEBUG
        print(error)
        #endif
        
        let toast = Toast(message: error.localizedDescription, type: .error)
        displayToast(toast)
    }
    
    private func displayToast(_ toast: Toast) {
        let delay: CGFloat = currentWorkItem == nil ? 0 : 0.2
        
        currentWorkItem?.cancel()
        withAnimation {
            currentToast = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            withAnimation {
                self?.currentToast = toast
            }
            
            let workItem = DispatchWorkItem { [weak self] in
                withAnimation {
                    self?.currentToast = nil
                }
            }
            
            self?.currentWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: workItem)
        }
    }
    
    func dismiss() {
        withAnimation {
            currentToast = nil
        }
    }
}
