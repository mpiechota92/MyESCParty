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
    
    func showToast(message: String, type: ToastType) {
        currentToast = Toast(message: message, type: type)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            withAnimation {
                self?.currentToast = nil
            }
        }
    }
    
    func showErrorToast(error: any Error) {
        #if DEBUG
        print(error)
        #endif
        
        currentToast = Toast(message: error.localizedDescription, type: .error)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            withAnimation {
                self?.currentToast = nil
            }
        }
    }
    
    func dismiss() {
        withAnimation {
            currentToast = nil
        }
    }
}
