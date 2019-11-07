//
//  Endpoints.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/11/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation
import Alamofire

// MARK: URLRequestConvertible
enum Router: URLRequestConvertible {
    case getLatest(query: String, page: Int, limit: Int)
    case getDetail(story: String)
    
    static let baseURLString = BaseURL.stories
    static let perPage = Identifiers.resultsPerPage
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters?) = {
            switch self {
            case let .getLatest(query, page, limit) where page > 0:
                return ("/latest", ["type": query, "page": page, "limit": limit])
            case let .getLatest(query, _, perPage):
                return ("/latest", ["type": query, "limit": perPage])
            case let .getDetail(story):
                return ("/\(story)", [:])
            }
        }()

        let url = try Router.baseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}

func fetchResults(page pageNumber: Int, completion: @escaping ([Story]?) -> Void) {
    Alamofire.request(Router.getLatest(query: Identifiers.standardPost, page: pageNumber, limit: 25)).response { response in
        guard let data = response.data else { return }
        do {
            let decoder = JSONDecoder()
            let curatedStories = try decoder.decode([Story].self, from: data)
            completion(curatedStories)
        } catch let error {
            print(error)
            completion(nil)
        }
    }
}
