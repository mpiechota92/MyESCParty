//
//  SupabaseExtensions.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 07/07/2025.
//

import Foundation
import Supabase

extension SupabaseClient {
    func from(_ table: DBTable) -> PostgrestQueryBuilder {
        self.from(table.rawValue)
    }
}
