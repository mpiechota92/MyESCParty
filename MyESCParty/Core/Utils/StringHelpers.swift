//
//  StringHelpers.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 12/06/2025.
//

extension String {
    func isEmailValid() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
