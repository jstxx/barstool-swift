//
//  Author.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/12/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation

struct Author: Decodable {
    var id: ValidID
    var name: String
    var author_url: String?
    var avatar: URL
    var twitter_handle: String?
    var has_notifications: Bool?
    var is_active: Bool
}
