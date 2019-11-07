//
//  StoryDetailViewController.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/11/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

final class StoryDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var articleWebContent: WKWebView!
    @IBOutlet weak var authorAvatarPosition: NSLayoutConstraint!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroImageHeight: NSLayoutConstraint!
    @IBOutlet weak var webViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var topOfTitle: NSLayoutConstraint!
    
    var chosenStory: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroImage.layer.masksToBounds = true
        self.navigationController?.isNavigationBarHidden = false
        self.articleWebContent.scrollView.delegate = self
        parentScrollView.delegate = self
        articleWebContent.scrollView.contentInsetAdjustmentBehavior = .never
        
        fetchDetail { data in
        }
        topOfTitle.constant = 50
        storyTitle.layoutIfNeeded()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let parallaxAmount: CGFloat = 1.15
        let parallaxSecondaryAmount: CGFloat = 1.28
        let parallaxAltAmount: CGFloat = 1.3
        storyTitle.alpha = 1
        
        authorAvatarPosition.constant -= parallaxSecondaryAmount * yOffset
        topOfTitle.constant += parallaxAltAmount * yOffset
        heroImageHeight.constant -= parallaxAmount * yOffset
        webViewTopAnchor.constant -= parallaxAmount * yOffset
        articleWebContent.scrollView.contentSize = CGSize(width: CGFloat(self.view.frame.size.width),
                                                          height: articleWebContent.scrollView.frame.size.height + yOffset)
    }
    
    func fetchDetail(completion: @escaping (Story?) -> Void) {
        guard let storyId = chosenStory?.id, let validId = storyId.get() as? String else { return }
        
        Alamofire.request(Router.getDetail(story: validId)).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let curatedStory = try decoder.decode(Story.self, from: data)
                if let hasImage = curatedStory.thumbnail?.raw {
                    self.heroImage.load(url: hasImage)
                }
                self.authorImage.load(url: curatedStory.author.avatar)
                self.authorName.text = curatedStory.author.name
                self.title = curatedStory.title
                self.navigationController?.title = curatedStory.brand_name
                self.storyTitle.text = curatedStory.title
                guard let parsedHTML = curatedStory.post_type_meta?.standard_post?.raw_content else { return }
                self.articleWebContent.loadHTMLString(parsedHTML, baseURL: nil)
                completion(curatedStory)
            } catch let error {
                completion(nil)
            }
        }
    }
}
