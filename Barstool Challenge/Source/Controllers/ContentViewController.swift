//
//  InitialViewController.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/11/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation

import UIKit
import Alamofire

final class ContentViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate, UINavigationBarDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet var storyCollection: UICollectionView!
    
    var pageNumber = 1
    let itemsPerRow: CGFloat = 2
    let cellInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 10.0, right: 5.0)
    var refresher: UIRefreshControl!
    
    var curatedStories: [Story] = []
    var filteredStories: [Story] = []
    
    let reuseIdentifier = Identifiers.storyCell
    var shouldDecelerate: Bool = false
    @IBOutlet weak var storySearcher: UISearchBar!
    
    private func initCollectionView() {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        storyCollection.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        self.refresher = UIRefreshControl()
        self.storyCollection!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(refreshStories), for: .valueChanged)
        self.storyCollection!.refreshControl = refresher
        
        storyCollection.dataSource = self
        storyCollection.delegate = self
        storySearcher.delegate = self
    }
    
    var selectedStory: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up peak-previewing if supported
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        self.navigationController?.delegate = self
        initCollectionView()
        hydrateResults(page: 1)
    }
    
    @objc func refreshStories() {
        hydrateResults(page: 1)
    }
    
    func stopRefresher() {
        self.storyCollection.refreshControl?.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStories = self.curatedStories.filter { (story) -> Bool in
            return story.author.name.lowercased().contains(searchText.lowercased()) || story.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        self.storyCollection.reloadData()
    }
}
