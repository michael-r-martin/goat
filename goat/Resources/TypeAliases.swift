//
//  TypeAliases.swift
//  goat
//
//  Created by Michael Martin on 01/08/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

struct FirebaseParameter {
    static let publicUsers = "publicUsers"
    static let privateUsers = "privateUsers"
    static let usersPosts = "posts"
    static let timestamp = "timestamp"
    static let newsFeed = "newsFeed"
    static let profileImagesStorageRef = "images/publicUsers/"
    static let imagePostsStorageRef = "images/imagePosts/"
}

struct SBIds {
    static let create = "Create"
}

struct VCIds {
    static let createPost = "CreatePost"
}

struct FirebaseCallConstructor {
    var db: Firestore
    var storageRef: StorageReference
    
    var collectionReferences: [CollectionReference] = []
    var documentReferences: [DocumentReference] = []
    var queryParameters: [Query] = []
    
    var firstCollection: CollectionReference?
    // etc
    
    init(database: Firestore, storageRef: StorageReference) {
        self.db = database
        self.storageRef = storageRef
    }
    
//    func constructCall() -> Query {
//        
//    }
}
