//
//  DependencyResolver.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/03/2025.
//

import Foundation
import Swinject

class DependencyResolver {
    static let shared = DependencyResolver()
    let container: Container
    
    private init() {
        self.container = Container()
        
        //container.register(DatabaseManagerProtocol.self) { _ in DatabaseManager() }
    }
}
