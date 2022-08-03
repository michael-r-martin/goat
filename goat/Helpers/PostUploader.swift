//
//  PostUploader.swift
//  goat
//
//  Created by Michael Martin on 31/07/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class PostUploader {
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var userId: String
    
    init?(userId: String?) {
        guard let userId = userId else {
            return nil
        }

        self.userId = userId
    }
    
    func uploadPost(post: ImagePost?) {
        guard let post = post else {
            return
        }
        
        uploadImageToStorage(fromPost: post)
        
        writePostToUsersPosts(post)
        
        // write to all friends' news feeds
        fetchFollowersList { ids in
            for id in ids {
                self.writePostToNewsFeed(post, userId: id)
            }
        }
    }
    
    func uploadImageToStorage(fromPost post: ImagePost) {
        let newImageRef = storageRef.child("\(FirebaseParameter.imagePostsStorageRef)\(post.userId)\(MediaExtensions.jpg)")
        
        guard let imageData = post.contentImage.jpegData(compressionQuality: 0.05) else {
            return
        }
        
        newImageRef.putData(imageData) { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(metadata):
                print(metadata)
            }
        }
    }
    
    func writePostToNewsFeed(_ post: ImagePost, userId: String) {
        let postData: [String: Any] = [
            "postId": post.postId,
            "userId": post.userId,
            "contentDescription": post.contentDescription,
            "username": post.username,
            "timestamp": post.timestamp
        ]
        
        let documentRef = db
            .collection(FirebaseParameter.publicUsers)
            .document(userId)
            .collection(FirebaseParameter.newsFeed)
        
        documentRef.addDocument(data: postData) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func writePostToUsersPosts(_ post: ImagePost) {
        let postData: [String: Any] = [
            "postId": post.postId,
            "userId": post.userId,
            "contentDescription": post.contentDescription,
            "username": post.username,
            "timestamp": post.timestamp
        ]
        
        let documentRef = db
            .collection(FirebaseParameter.publicUsers)
            .document(userId)
            .collection(FirebaseParameter.usersPosts)
        
        documentRef.addDocument(data: postData) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func fetchFollowersList(completion: @escaping (_ friendsIds: [String]) -> Void) {
        db.collection("privateUsers")
            .document(userId)
            .collection("friends")
            .getDocuments { snapshot, error in
                var fetchedFriendIds: [String] = []
                
                guard let documents = snapshot?.documents else {
                    return
                }
                
                for document in documents {
                    fetchedFriendIds.append(document.documentID)
                }
                
                completion(fetchedFriendIds)
            }
    }
}
