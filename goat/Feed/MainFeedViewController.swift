//
//  MainFeedViewController.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import UIKit

class MainFeedViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    // MARK: - Classes
    let imagePostDownloader = ImagePostDownloader()
    
    // MARK: - Env. Variables
    var rawCurrentPost: ImagePostAPIResponse?
    var fullCurrentPost: ImagePost?
    var previousPost: ImagePost?
    var postCollection: [ImagePostAPIResponse] = []
    
    // MARK: - State Variables
    var shouldShowLoadingPlaceholderPost: Bool = true
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePostDownloader.delegate = self
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        let newsFeedOptions = ImagePostDownloadOptions(currentUserId: <#T##String?#>, postToFetchId: <#T##String?#>, postLimit: <#T##Int?#>, afterPostId: <#T##String?#>)
        imagePostDownloader.downloadContentCollection(collectionType: ContentCollection.newsFeed("currentUserId"))
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    // MARK: - UI Methods

}

extension MainFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = feedCollectionView.bounds.width
        let height = feedCollectionView.bounds.height
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        if shouldShowLoadingPlaceholderPost {
            return dequeueLoadingPlaceholderCell(indexPath: indexPath)
        }
        
        if fullyLoadedCellIndices.contains(row) {
            return dequeueCellWithImage(indexPath: indexPath)
        } else {
            return dequeueCellWithoutImage(indexPath: indexPath)
        }
    }
    
    func dequeueCellWithImage(indexPath: IndexPath) -> MainFeedCollectionViewCell {
        guard let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "MainFeed", for: indexPath) as? MainFeedCollectionViewCell else {
            return MainFeedCollectionViewCell()
        }
        
        cell.userImageView.image = fullCurrentPost?.userImage
        cell.usernameLabel.text = fullCurrentPost?.username
        cell.contentImageView.image = fullCurrentPost?.contentImage
        cell.contentDescriptionLabel.text = fullCurrentPost?.contentDescription
        cell.timeAgoLabel.text = fullCurrentPost?.$timeAgo
        
        cell.styleCell()
        
        return cell
    }
    
    func dequeueCellWithoutImage(indexPath: IndexPath) -> MainFeedCollectionViewCell {
        let row = indexPath.row
        
        let specificPost = postCollection[row]
        
        guard let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "MainFeed", for: indexPath) as? MainFeedCollectionViewCell else {
            return MainFeedCollectionViewCell()
        }
        
        cell.userImageView.image = UIImage() // add default
        cell.usernameLabel.text = specificPost.username
        cell.contentImageView.image = UIImage() // add default
        cell.contentDescriptionLabel.text = specificPost.contentDescription
        
        cell.styleCell()
        
        return cell
    }
    
    func dequeueLoadingPlaceholderCell(indexPath: IndexPath) -> MainFeedCollectionViewCell {
        guard let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "MainFeed", for: indexPath) as? MainFeedCollectionViewCell else {
            return MainFeedCollectionViewCell()
        }
        
        cell.userImageView.image = UIImage(named: "profileImage") // add default
        cell.usernameLabel.text = "loading..."
        cell.contentImageView.image = UIImage(named: "contentImage") // add default
        cell.contentDescriptionLabel.text = "loading..."
        
        cell.styleCell()
        
        return cell
    }
}

// Scroll View
extension MainFeedViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
        
        shouldShowLoadingPlaceholderPost = true

        feedCollectionView.reloadData()
        
        if translation.y < 0 {
            imagePostDownloader.fetchFullPost()
            
            previousPost = fullCurrentPost
        } else {
            shouldShowLoadingPlaceholderPost = false
            
            fullCurrentPost = previousPost
            
            feedCollectionView.reloadData()
        }
    }
}

// Image download delegate
extension MainFeedViewController: ImagePostDownloadDelegate {
    func didAttemptCollectionDownload(collection: [ImagePostAPIResponse], error: String?) {
        if let error = error {
            print(error)
            return
        }
        
        self.postCollection = collection
        
        self.shouldShowLoadingPlaceholderPost = false
        
        self.feedCollectionView.reloadData()
        
        self.imagePostDownloader.fetchFullPost()
    }
    
    func didAttemptFullPostDownload(fullPost: ImagePost, error: String?) {
        if let error = error {
            print(error)
            return
        }
        
        self.fullCurrentPost = fullPost
        
        self.shouldShowLoadingPlaceholderPost = false
        
        self.feedCollectionView.reloadData()
    }
    
    var fullyLoadedCellIndices: [Int] {
        return imagePostDownloader.fullyLoadedCellIndices
    }
}
