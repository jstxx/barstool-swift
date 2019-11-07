//
//  Images.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/12/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation

struct ImageRepresentable: Codable {
    var small: String?
    var medium: String?
    var large: String?
}

struct Thumbnail: Codable {
    var type: String?
    var location: URL?
    var images: ImageRepresentable?
    var desktop: URL?
    var raw: URL?
    var raw_desktop: URL?
}
