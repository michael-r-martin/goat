//
//  ContentDownloader.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation
import FirebaseFirestore

enum ContentType: String {
    case publicUserProfile = "publicUsers"
    case imagePost = "imagePosts"
    case privateUserProfile = "privateUsers"
}

class ContentDownloader {
    
    let db = Firestore.firestore()
    
    weak var delegate: ContentDownloadDelegate?
    
    func downloadContent(_ id: String?, contentType: ContentType) {
        guard let id = id else {
            return
        }
        
        db.collection(contentType.rawValue).document(id).getDocument { snapshot, error in
            var downloadValidator = DownloadValidator(snapshot: snapshot, snapshotDocuments: nil, error: error)
            
            try? downloadValidator.validateDocument()
            try? downloadValidator.serializeDocumentIntoData()
            
            switch contentType {
            case .publicUserProfile:
                let objectToParse = AnyParsedObject<PublicUserAPIResponse>()
                
                guard let parsedData = try? objectToParse.parseObject(downloadValidator.validData) else {
                    return
                }
                
                self.delegate?.didAttemptContentDownload(downloadStatus: .rawContentFetched(parsedData), contentType: contentType, error: nil)
            case .imagePost:
                let objectToParse = AnyParsedObject<ImagePostAPIResponse>()
                
                guard let parsedData = try? objectToParse.parseObject(downloadValidator.validData) else {
                    return
                }
                
                self.delegate?.didAttemptContentDownload(downloadStatus: .rawContentFetched(parsedData), contentType: contentType, error: nil)
            case .privateUserProfile:
                let objectToParse = AnyParsedObject<PrivateUserAPIResponse>()
                
                guard let parsedData = try? objectToParse.parseObject(downloadValidator.validData) else {
                    return
                }
                
                self.delegate?.didAttemptContentDownload(downloadStatus: .rawContentFetched(parsedData), contentType: contentType, error: nil)
            }
        }
    }
    
    func downloadContentCollection(contentType: ContentType) {
        var fetchedContentCollection: [Any] = []
        
        db.collection(contentType.rawValue).getDocuments { snapshot, error in
            var downloadValidator = DownloadValidator(snapshot: nil, snapshotDocuments: snapshot, error: error)
            
            try? downloadValidator.validateCollection()
            try? downloadValidator.serializeCollectionIntoDataArray()
            
            for item in downloadValidator.validDataArray {
                switch contentType {
                case .publicUserProfile:
                    let objectToParse = AnyParsedObject<PublicUserAPIResponse>()
                    
                    guard let parsedData = try? objectToParse.parseObject(item) else {
                        return
                    }
                    
                    fetchedContentCollection.append(parsedData)
                case .imagePost:
                    let objectToParse = AnyParsedObject<ImagePostAPIResponse>()
                    
                    guard let parsedData = try? objectToParse.parseObject(item) else {
                        return
                    }
                    
                    fetchedContentCollection.append(parsedData)
                default: break
                }
            }
            
            self.delegate?.didAttemptContentCollectionDownload(downloadStatus: .rawCollectionFetched(fetchedContentCollection), contentType: contentType, error: nil)
        }
    }
    
}

protocol ContentDownloadDelegate: AnyObject {
    func didAttemptPublicUserProfileDownload(downloadStatus: DownloadStatus, contentType: ContentType, error: String?)
    
    func didAttemptPrivateUserProfileDownload(downloadStatus: DownloadStatus, contentType: ContentType, error: String?)
    
    func didAttemptImageDownload(downloadStatus: DownloadStatus, error: String?)
}

enum DownloadStatus {
    case rawContentFetched(Any)
    case rawCollectionFetched(Any)
    case imageFetched(Any)
    case allImagesFetched(Any)
}
