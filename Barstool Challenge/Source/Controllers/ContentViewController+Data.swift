//
//  ContentViewController+Data.swift
//  Barstool Challenge
//
//  Created by Justin Savory on 10/12/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import UIKit

extension ContentViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if filteredStories.count > 0 {
            return filteredStories.count
        }
        return curatedStories.count
    }
    
    func appendStoriesView(numberOfItems count: Int) {
        let firstIdx = curatedStories.count - count
        let lastIdx = curatedStories.count - 1
        
        var indexPaths = [IndexPath]()
        for index in firstIdx...lastIdx {
            let indexPath = IndexPath(item: index, section: 0)
            indexPaths.append(indexPath)
        }
        
        UIView.animate(withDuration: 0.24, animations: {
            self.storyCollection.performBatchUpdates({ () -> Void in
                self.storyCollection.insertItems(at: indexPaths)
            })
        })
    }
    
    func hydrateResults(page pageNumber: Int) {
        storyCollection.refreshControl?.beginRefreshing()
        fetchResults(page: pageNumber) {[unowned self] data in
            guard let fetchedData = data else { return }
            for results in fetchedData {
                self.curatedStories.append(results)
            }
            self.stopRefresher()
            self.appendStoriesView(numberOfItems: fetchedData.count)
            self.storyCollection.setNeedsLayout()
            self.storyCollection.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard shouldDecelerate else { return }
        shouldDecelerate = false
        pageNumber += 1
        hydrateResults(page: pageNumber)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pageNumber += 1
            hydrateResults(page: pageNumber)
            shouldDecelerate = false
        }
        shouldDecelerate = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedStory = curatedStories[indexPath.row]
        performSegue(withIdentifier: Identifiers.chosenStory, sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.chosenStory {
            let storyDetail = segue.destination as! StoryDetailViewController
            storyDetail.chosenStory = selectedStory
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StoryCell {
                cell.thumbnailImage.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let storyContent = story(for: indexPath)
        selectedStory = storyContent
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StoryCell {
                cell.thumbnailImage.transform = .init(scaleX: 0.70, y: 0.70)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
        
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let storyCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            as? StoryCell else {
                fatalError("Unable to dequeue StoryCell")
        }
        
        let storyContent = story(for: indexPath)
        
        storyCell.backgroundColor = .clear
        storyCell.layer.borderWidth = 1
        storyCell.layer.cornerRadius = 4
        storyCell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.28).cgColor
        
        let thumbnailPath = storyContent.thumbnail?.location?.absoluteString ?? ""
        
        if let thumbnail = storyContent.thumbnail?.images?.small {
            let constructedThumbnail = thumbnailPath + thumbnail
            if let thumbnailURL = URL(string: constructedThumbnail) {
                storyCell.thumbnailImage.load(url:thumbnailURL)
            }
        }
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .backgroundColor: UIColor.white.withAlphaComponent(0.88)]
        
        let attributedTitle = NSAttributedString(string: storyContent.title ?? "", attributes: titleAttributes)
        let attributedAuthor = NSAttributedString(string: "By: " + (storyContent.author.name), attributes: titleAttributes)
        let attributedBrandName = NSAttributedString(string: storyContent.brand_name ?? "", attributes: titleAttributes)
        
        storyCell.brandName.attributedText = attributedBrandName
        storyCell.authorName.attributedText = attributedAuthor
        storyCell.storyTitle.attributedText = attributedTitle
        storyCell.brandName.layoutIfNeeded()
        storyCell.layoutIfNeeded()
        return storyCell
    }
    
    func story(for indexPath: IndexPath) -> Story {
        if filteredStories.count > 0 {
            return filteredStories[indexPath.row]
        }
        return curatedStories[indexPath.row]
    }
}
