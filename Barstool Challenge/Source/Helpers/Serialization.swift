//
//  Serialization.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/11/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation
import SwiftSoup

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data, options: JSONSerialization) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

extension Optional {
    func resolve(with error: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case .none: throw error()
        case .some(let wrapped): return wrapped
        }
    }
    
    func or(_ other: Optional) -> Optional {
        switch self {
        case .none: return other
        case .some: return self
        }
    }
}

func parseHTML(story: String) -> String {
    do {
        let unsafe: String = story
        let safe: String = try SwiftSoup.clean(unsafe, Whitelist.basic())!
        
        return safe
    } catch Exception.Error(_, let message) {
        print(message)
    } catch {
        print("error")
    }
    return ""
}
