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
    var nextFullPostIndexToFetch: Int = 0
    
    func downloadContentCollection() {
        db.collection(ContentCollection.imagePosts.rawValue).getDocuments { snapshot, error in
            
            var downloadValidator = DownloadValidator(snapshot: nil, snapshotDocuments: snapshot, error: error)
            
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
        let postToFetch = fetchedContentCollection[nextFullPostIndexToFetch]
        
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
        
        let userImageChildRef = storageRef.child("images/publicusers/\(userImageIdToFetch).jpg")
        
        let contentImageChildRef = storageRef.child("images/imagePosts/\(contentImageIdToFetch).jpg")
        
        var userImage = UIImage()
        var contentImage = UIImage()
        
        let imageDispatchGroup = DispatchGroup()
        
        userImageChildRef.getData(maxSize: 10*1024*1024) { imageData, error in
            imageDispatchGroup.enter()
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
        
        contentImageChildRef.getData(maxSize: 10*1024*1024) { imageData, error in
            imageDispatchGroup.enter()
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
            self.nextFullPostIndexToFetch += 1
            
            guard let fullPost = self.mapApiResponseIntoUsableObject(apiResponse: postToFetch, userImage: userImage, contentImage: contentImage) else {
                return
            }
            
            self.delegate?.didAttemptFullPostDownload(fullPost: fullPost, error: nil)
        }
    }
    
    func mapApiResponseIntoUsableObject(apiResponse: ImagePostAPIResponse, userImage: UIImage, contentImage: UIImage) -> ImagePost? {
        
        guard let postId = apiResponse.postId, let userId = apiResponse.userId, let contentDescription = apiResponse.contentDescription, let username = apiResponse.username, let timestamp = apiResponse.timestamp else {
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
    
    func downloadIndividualPost(_ id: String?) {
        guard let id = id else {
            return
        }
        
        db.collection(ContentCollection.imagePosts.rawValue).document(id).getDocument { snapshot, error in
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
}
