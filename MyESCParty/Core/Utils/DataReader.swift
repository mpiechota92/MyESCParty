//
//  DataReader.swift
//  MyESCParty
//
//  Created by Maciej Piechota on 01/08/2025.
//

import Foundation

enum DemoDataReaderError: Error {
    case couldNotRead
}

struct DemoDataReader {
    static func getDataForTable<T: Decodable>(table: DBTable) throws -> T? {
        guard let url = Bundle.main.url(forResource: table.rawValue, withExtension: "json") else {
            print("Could not find \(table.rawValue).json")
            return nil
        }
        
        let data = try Data(contentsOf: url)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
