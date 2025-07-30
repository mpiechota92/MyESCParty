//
//  ValidatorManager.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 17/07/2025.
//

import Foundation

struct ValidatorType: OptionSet {
    let rawValue: Int
    
    static let email: ValidatorType = ValidatorType(rawValue: 1 << 0)
    static let password: ValidatorType = ValidatorType(rawValue: 1 << 1)
    static let profanity: ValidatorType = ValidatorType(rawValue: 1 << 2)
    static let notEmpty: ValidatorType = ValidatorType(rawValue: 1 << 3)
}

enum ValidationState {
    case valid
    case invalid(reason: String)
    case empty
}

struct Validator {
    let types: ValidatorType
    
    func validate(_ value: String) -> ValidationState {
        for type in ValidatorType.allCases {
            guard types.contains(type) else { continue }
            
            switch type {
            case .email:
                if !value.isEmailValid() {
                    return .invalid(reason: "Email is not valid")
                }
            case .password:
                return .valid
            case .profanity:
                return .valid
            case .notEmpty:
                if value.isEmpty {
                    return .empty
                }
            default:
                return .invalid(reason: "Not recognized validator type")
            }
        }
        
        return .valid
    }
}

extension ValidatorType: CaseIterable {
    static var allCases: [ValidatorType] {
        [.email, .password, .profanity, .notEmpty]
    }
}
