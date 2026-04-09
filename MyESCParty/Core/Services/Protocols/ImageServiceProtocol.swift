//
//  ImageServiceProtocol.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 02/04/2026.
//

import Foundation

protocol ImageServiceProtocol {
    func fetch(from urlString: String) async throws -> Data
}
