//
//  Category.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/12/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation

struct CategoryRepresentable: Decodable {
    var id: ValidID
    var slug: String
    var name: String
}
