//
//  Content.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/12/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation

struct RawContent: Decodable {
    var raw_content: String?
    var content: String?
}

struct PostContent: Decodable {
    var standard_post: RawContent?
}
