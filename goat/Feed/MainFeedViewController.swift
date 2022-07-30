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
    var postCollection: [ImagePostAPIResponse] = []
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    // MARK: - UI Methods

}

extension MainFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.bounds.width, height: view.bounds.height*0.8)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueCell(indexPath: indexPath)
    }
    
    func dequeueCell(indexPath: IndexPath) -> MainFeedCollectionViewCell {
        guard let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "MainFeed", for: indexPath) as? MainFeedCollectionViewCell else {
            return MainFeedCollectionViewCell()
        }
        
        cell.userImageView.image = fullCurrentPost?.userImage
        cell.usernameLabel.text = fullCurrentPost?.username
        cell.contentImageView.image = fullCurrentPost?.contentImage
        cell.contentDescriptionLabel.text = fullCurrentPost?.contentDescription
        cell.timeAgoLabel.text = fullCurrentPost?.$timeAgo
        
        return cell
    }
}

extension MainFeedViewController: ImagePostDownloadDelegate {
    func didAttemptCollectionDownload(collection: [ImagePostAPIResponse], error: String?) {
        
    }
    
    func didAttemptFullPostDownload(fullPost: ImagePost, error: String?) {
        
    }
}
