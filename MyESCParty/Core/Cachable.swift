//
//  Cachable.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 07/07/2025.
//

import Foundation

protocol Cachable {
    var cacheTimestamp: Date? { get set }
    var cacheTTL: TimeInterval { get }
}

extension Cachable {
    var cacheTTL: TimeInterval {
        300
    }
}
