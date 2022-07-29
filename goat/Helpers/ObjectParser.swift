//
//  ObjectParser.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation

protocol Parseable {
    associatedtype ParsedObject
    
    func parseObject(_ objectData: Data) throws -> ParsedObject
}

struct AnyParsedObject<T: Codable>: Parseable {
    typealias ParsedObject = T
    
    let decoder = JSONDecoder()
    
    func parseObject(_ objectData: Data) throws -> T {
        do {
            let parsedObject = try decoder.decode(T.self, from: objectData)
            return parsedObject
        } catch {
            throw error
        }
    }
}
