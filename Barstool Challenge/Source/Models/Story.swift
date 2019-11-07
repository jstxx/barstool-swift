//
//  Story.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/11/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation

struct Story: Decodable {
    var id: ValidID?
    var brand_id: ValidID?
    var brand_name: String?
    var title: String?
    var type: String?
    var url: URL?
    var branch_url: URL?
    var thumbnail: Thumbnail?
    var nsfw: Bool?
    var comment_count: Int64?
    var comment_status_open: Bool?
    var category: [CategoryRepresentable]?
    var tag: String?
    var tags: [String]?
    var author: Author
    var post_type_meta: PostContent?
}

struct StoryResults: Decodable {
    var results: [Story]
}
