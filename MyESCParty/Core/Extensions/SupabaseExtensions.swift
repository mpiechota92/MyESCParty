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
    
    func rpc(
      _ fn: DBFunction,
      count: CountOption? = nil
    ) throws -> PostgrestFilterBuilder {
        try self.rpc(fn.rawValue, count: count)
    }
}

extension SupabaseStorageClient {
    func from(_ table: DBStorageBucket) -> StorageFileApi {
        self.from(table.rawValue)
    }
}
