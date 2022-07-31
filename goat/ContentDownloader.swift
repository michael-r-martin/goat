//
//  ContentDownloader.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

//import Foundation
//import FirebaseFirestore
//
//class ContentDownloader {
//    
//    let db = Firestore.firestore()
//    
//    weak var delegate: ContentDownloadDelegate?
//    
//    func downloadContent(_ id: String?, contentType: ContentCollection) {
//        guard let id = id else {
//            return
//        }
//        
//        db.collection(contentType.rawValue).document(id).getDocument { snapshot, error in
//            var downloadValidator = DownloadValidator(snapshot: snapshot, snapshotDocuments: nil, error: error)
//            
//            try? downloadValidator.validateDocument()
//            try? downloadValidator.serializeDocumentIntoData()
//            
//            switch contentType {
//            case .publicUserProfile:
//                let objectToParse = AnyParsedObject<PublicUserAPIResponse>()
//                
//                guard let parsedData = try? objectToParse.parseObject(downloadValidator.validData) else {
//                    return
//                }
//                
//               // self.delegate?.didAttemptContentDownload(downloadStatus: .rawContentFetched(parsedData), contentType: contentType, error: nil)
//            case .imagePosts:
//                let objectToParse = AnyParsedObject<ImagePostAPIResponse>()
//                
//                guard let parsedData = try? objectToParse.parseObject(downloadValidator.validData) else {
//                    return
//                }
//                
//                //self.delegate?.didAttemptContentDownload(downloadStatus: .rawContentFetched(parsedData), contentType: contentType, error: nil)
//            case .privateUserProfile:
//                let objectToParse = AnyParsedObject<PrivateUserAPIResponse>()
//                
//                guard let parsedData = try? objectToParse.parseObject(downloadValidator.validData) else {
//                    return
//                }
//                
//                //self.delegate?.didAttemptContentDownload(downloadStatus: .rawContentFetched(parsedData), contentType: contentType, error: nil)
//            }
//        }
//    }
//    
//    func downloadContentCollection(contentType: ContentCollection) {
//        var fetchedContentCollection: [Any] = []
//        
//        db.collection(contentType.rawValue).getDocuments { snapshot, error in
//            var downloadValidator = DownloadValidator(snapshot: nil, snapshotDocuments: snapshot, error: error)
//            
//            try? downloadValidator.validateCollection()
//            try? downloadValidator.serializeCollectionIntoDataArray()
//            
//            for item in downloadValidator.validDataArray {
//                switch contentType {
//                case .publicUserProfile:
//                    let objectToParse = AnyParsedObject<PublicUserAPIResponse>()
//                    
//                    guard let parsedData = try? objectToParse.parseObject(item) else {
//                        return
//                    }
//                    
//                    fetchedContentCollection.append(parsedData)
//                case .imagePosts:
//                    let objectToParse = AnyParsedObject<ImagePostAPIResponse>()
//                    
//                    guard let parsedData = try? objectToParse.parseObject(item) else {
//                        return
//                    }
//                    
//                    fetchedContentCollection.append(parsedData)
//                default: break
//                }
//            }
//            
//            //self.delegate?.didAttemptContentCollectionDownload(downloadStatus: .rawCollectionFetched(fetchedContentCollection), contentType: contentType, error: nil)
//        }
//    }
//    
//}
//
//protocol ContentDownloadDelegate: AnyObject {
//    func didAttemptPublicUserProfileDownload(downloadStatus: DownloadStatus, contentType: ContentCollection, error: String?)
//    
//    func didAttemptPrivateUserProfileDownload(downloadStatus: DownloadStatus, contentType: ContentCollection, error: String?)
//    
//    func didAttemptImageDownload(downloadStatus: DownloadStatus, error: String?)
//    
//    var rawPublicUserProfile: PublicUserAPIResponse { get set }
//    
//    var fullPublicUserProfile: PublicUser { get set }
//    
//    var rawPublicUserProfileCollection: [PublicUserAPIResponse] { get set }
//    
//    var fullPublicUserProfileCollection: [PublicUser] { get set }
//    
//    var rawPrivateUserProfile: PrivateUserAPIResponse { get set }
//    
//    var fullPrivateUserProfile: PrivateUser { get set }
//    
//    var rawImagePost: ImagePostAPIResponse { get set }
//    
//    var fullImagePost: ImagePost { get set }
//    
//    var rawImagePostCollection: [ImagePostAPIResponse] { get set }
//    
//    var fullImagePostCollection: [ImagePost] { get set }
//}
