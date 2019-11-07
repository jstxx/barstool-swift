//
//  ValidID.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/12/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation

public enum ValidID: Decodable {
    case string(String)
    case int(Int)
    
    func get() -> String {
        switch self {
        case .int(let num):
            return String(describing: num)
        case .string(let num):
            return num
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try ((try? container.decode(String.self)).map(ValidID.string))
            .or((try? container.decode(Int.self)).map(ValidID.int))
            .resolve(with: DecodingError.typeMismatch(ValidID.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a valid ID")))
    }
}
