//
//  CreatePostViewController.swift
//  goat
//
//  Created by Michael Martin on 02/08/2022.
//

import UIKit

class CreatePostViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mediaPickerView: UIView!
    @IBOutlet weak var selectedPhotoImageView: UIImageView!
    @IBOutlet weak var mediaGalleryCollectionView: UICollectionView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var postButtonView: UIView!
    @IBOutlet weak var postButtonImageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    
    // MARK: - Dependencies
    let photosFetcher = MediaLibraryFetcher()
    var postUploader: PostUploader?
    
    // MARK: - Env. Variables
    var photos: [UIImage] = []
    var postToUpload: ImagePost?
    
    // MARK: - VC Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photosFetcher.requestAuthorization { [weak self] authorized in
            if authorized {
                self?.photosFetcher.fetchPhotos()
            }
        }
        
        postUploader = PostUploader(userId: "mikey")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photosFetcher.delegate = self
        mediaGalleryCollectionView.delegate = self
        mediaGalleryCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        styleView()
    }
    
    // MARK: - IB Actions
    @IBAction func postButtonTapped(_ sender: Any) {
        
        postUploader?.uploadPost(post: postToUpload)
    }
    
    
    // MARK: - UI Methods
    func styleView() {
        postButtonView.applyCurvedCorners(0.5)
        selectedPhotoImageView.applyCurvedCorners(0.1)
    }

}

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
}

extension CreatePostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = mediaGalleryCollectionView.bounds.width/2
        let height = width
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueImageCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        
        let selectedImage = photos[selectedRow]
        
        selectedPhotoImageView.isHidden = false
        selectedPhotoImageView.image = selectedImage
    }
    
    func dequeueImageCell(indexPath: IndexPath) -> PhotoLibraryCollectionViewCell {
        let specificRow = indexPath.row
        
        let specificImage = photos[specificRow]
        
        guard let cell = mediaGalleryCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibrary", for: indexPath) as? PhotoLibraryCollectionViewCell else { return PhotoLibraryCollectionViewCell() } // return default here
        
        cell.mainImageView.image = specificImage
        
        cell.styleCell()
        
        return cell
    }
}

extension CreatePostViewController: MediaLibraryFetchDelegate {
    func didAttemptImageFetch(images: [UIImage], error: String?) {
        self.photos = images
        mediaGalleryCollectionView.reloadData()
    }
    
}
