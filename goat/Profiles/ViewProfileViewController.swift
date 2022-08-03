//
//  ViewProfileViewController.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import UIKit

class ViewProfileViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var profileImageBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var addFriendButtonView: UIView!
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBOutlet weak var profileMediaCollectionView: UICollectionView!
    
    // MARK: - Dependencies
    let imageDownloader = ImagePostDownloader()
    let userDownloader = UserDownloader()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageDownloader.downloadContentCollection(userId: "mikey", options: .init(postLimit: 9, collectionType: .userImages(nil)))
        
        // need a flag for determining if it's a users' own profile
        userDownloader.downloadIndividualUser("mikey", userType: .publicUserProfile(nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileMediaCollectionView.delegate = self
        profileMediaCollectionView.dataSource = self
        
        imageDownloader.delegate = self
        userDownloader.delegate = self
    }
}

extension ViewProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = profileMediaCollectionView.bounds.width/3
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

extension ViewProfileViewController: ImagePostDownloadDelegate {
    func didAttemptCollectionDownload(collection: [ImagePostAPIResponse], error: String?) {
        <#code#>
    }
    
    func didAttemptFullPostDownload(fullPost: ImagePost, error: String?) {
        <#code#>
    }
    
    var fullyLoadedCellIndices: [Int]? {
        return nil
    }
}

extension ViewProfileViewController: UserDownloadDelegate {
    func didAttemptRawUserDownload(rawUser: UserAPIResponse, error: String?) {
        if let error = error {
            print(error)
            return
        }
        
        self.usernameLabel.text = rawUser.username
    }
    
    func didAttemptFullUserDownload(fullUser: User, error: String?) {
        if let error = error {
            print(error)
            return
        }
        
        self.profileImageView.image = fullUser.profileImage
    }
    
}

