//
//  ContentViewControllerPeak.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/12/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import UIKit

extension ContentViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let storyDetail = storyboard?
            .instantiateViewController(withIdentifier: Identifiers.storyDetail)
            as? StoryDetailViewController else { return nil }
        
        storyDetail.chosenStory = selectedStory
        storyDetail.preferredContentSize =
            CGSize(width: 0, height: 400)
        return storyDetail
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        navigationController?.show(viewControllerToCommit, sender: nil)
    }
}


