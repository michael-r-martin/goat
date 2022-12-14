//
//  ImagePostDownloader.swift
//  goat
//
//  Created by Michael Martin on 30/07/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ImagePostDownloader {
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    weak var delegate: ImagePostDownloadDelegate?
    
    var fetchedContentCollection: [ImagePostAPIResponse] = []
    var lastFetchedIndex: Int = 0
    var fullyLoadedCellIndices: [Int] = []
    var lastFetchedDocument: DocumentSnapshot?
    
    func downloadContentCollection(userId: String?, options: ImagePostDownloadOptions) {
        var collectionToFetch: Query?
        
        guard let userId = userId else {
            return
        }
        
        switch options.collectionType {
        case .userImages:
            collectionToFetch = db
                .collection(FirebaseParameter.publicUsers)
                .document(userId)
                .collection(FirebaseParameter.usersPosts)
                .limit(to: options.postLimit)
                .order(by: FirebaseParameter.timestamp, descending: true)
        case .newsFeed:
            collectionToFetch = db
                .collection(FirebaseParameter.publicUsers)
                .document(userId)
                .collection(FirebaseParameter.newsFeed)
                .limit(to: options.postLimit)
                .order(by: FirebaseParameter.timestamp, descending: true)
        default: return
        }
        
        if let nextToFetch = lastFetchedDocument {
            collectionToFetch?.start(afterDocument: nextToFetch)
        }
        
        collectionToFetch?.getDocuments { snapshot, error in
            
            var downloadValidator = DownloadValidator(snapshot: nil, snapshotDocuments: snapshot, error: error)
            
            self.lastFetchedDocument = snapshot?.documents.last
            
            var validDataArray: [Data] = []
            
            do {
                let validDocumentCollection = try downloadValidator.validateCollection()
                
                validDataArray = try downloadValidator.serializeCollectionIntoDataArray(validDataDictionaryArray: validDocumentCollection)
            } catch {
                print(error.localizedDescription)
            }
            
            for item in validDataArray {
                let objectToParse = AnyParsedObject<ImagePostAPIResponse>()
                
                guard let parsedData = try? objectToParse.parseObject(item) else {
                    return
                }
                
                self.fetchedContentCollection.append(parsedData)
            }
            
            self.delegate?.didAttemptCollectionDownload(collection: self.fetchedContentCollection, error: nil)
        }
    }
    
    func fetchFullPost() {
        var postToFetch = ImagePostAPIResponse()
        
        if fetchedContentCollection.count > lastFetchedIndex {
            postToFetch = fetchedContentCollection[lastFetchedIndex]
        }
        
        let userImageIdToFetch = postToFetch.userId
        
        let contentImageIdToFetch = postToFetch.postId
        
        guard let userImageIdToFetch = userImageIdToFetch else {
            print(#file, #function, #line)
            return
        }
        
        guard let contentImageIdToFetch = contentImageIdToFetch else {
            print(#file, #function, #line)
            return
        }
        
        let userImageChildRef = storageRef.child("\(FirebaseParameter.profileImagesStorageRef)\(userImageIdToFetch)\(MediaExtensions.jpg)")
        
        let contentImageChildRef = storageRef.child("\(FirebaseParameter.imagePostsStorageRef)\(contentImageIdToFetch)\(MediaExtensions.jpg)")
        
        var userImage = UIImage()
        var contentImage = UIImage()
        
        let imageDispatchGroup = DispatchGroup()
        
        imageDispatchGroup.enter()
        userImageChildRef.getData(maxSize: 10*1024*1024) { imageData, error in
            defer { imageDispatchGroup.leave() }
            
            // refactor
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let imageData = imageData else {
                print(#file, #function, #line)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                print(#file, #function, #line)
                return
            }
            
            userImage = image
        }
        
        imageDispatchGroup.enter()
        contentImageChildRef.getData(maxSize: 10*1024*1024) { imageData, error in
            defer { imageDispatchGroup.leave() }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let imageData = imageData else {
                print(#file, #function, #line)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                print(#file, #function, #line)
                return
            }
            
            contentImage = image
        }
        
        imageDispatchGroup.notify(queue: .main) {
            self.fullyLoadedCellIndices.append(self.lastFetchedIndex)
            
            self.lastFetchedIndex += 1
            
            guard let fullPost = self.mapApiResponseIntoUsableObject(apiResponse: postToFetch, userImage: userImage, contentImage: contentImage) else {
                return
            }
            
            self.delegate?.didAttemptFullPostDownload(fullPost: fullPost, error: nil)
        }
    }
    
    func mapApiResponseIntoUsableObject(apiResponse: ImagePostAPIResponse, userImage: UIImage, contentImage: UIImage) -> ImagePost? {
        
        guard let postId = apiResponse.postId,
              let userId = apiResponse.userId,
              let contentDescription = apiResponse.contentDescription,
              let username = apiResponse.username,
              let timestamp = apiResponse.timestamp else {
            return nil
        }
        
        let imagePost = ImagePost(postId: postId,
                                  userId: userId,
                                  userImage: userImage,
                                  contentImage: contentImage,
                                  contentDescription: contentDescription,
                                  username: username,
                                  timestamp: timestamp,
                                  timeAgo: timestamp)
        
        // could i use property wrappers to do this automatically?
        
        return imagePost
    }
    
    func downloadIndividualPost(userId: String?, postId: String?) {
        guard let userId = userId else {
            return
        }
        
        guard let postId = postId else {
            return
        }
        
        let documentReference = db
            .collection(FirebaseParameter.publicUsers)
            .document(userId)
            .collection(FirebaseParameter.usersPosts)
            .document(postId)
        
        documentReference.getDocument { snapshot, error in
            var downloadValidator = DownloadValidator(snapshot: snapshot, snapshotDocuments: nil, error: error)
            
            var parseableData = Data()
            
            do {
                let validDocument = try downloadValidator.validateDocument()
                
                parseableData = try downloadValidator.serializeDocumentIntoData(validDataDictionary: validDocument)
            } catch {
                print(error.localizedDescription)
            }
            
            let objectToParse = AnyParsedObject<ImagePostAPIResponse>()
            
            guard let parsedData = try? objectToParse.parseObject(parseableData) else {
                return
            }
        }
    }
}

protocol ImagePostDownloadDelegate: AnyObject {
    func didAttemptCollectionDownload(collection: [ImagePostAPIResponse], error: String?)
    
    func didAttemptFullPostDownload(fullPost: ImagePost, error: String?)
    
    var fullyLoadedCellIndices: [Int]? { get }
}
