//
//  StoryViewCell.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/11/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import UIKit

class StoryCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var brandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        storyTitle.preferredMaxLayoutWidth = 150
    }
}
