//
//  UserDownloader.swift
//  goat
//
//  Created by Michael Martin on 30/07/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class UserDownloader {
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    weak var delegate: UserDownloadDelegate?
    
    func downloadUserCollection() {
        db.collection(FirebaseParameter.publicUsers).getDocuments { snapshot, error in
            
            var parsedUsers: [UserAPIResponse] = []
            var fullUserCollection: [User] = []
            var validDataArray: [Data] = []
            let myDispatchGroup = DispatchGroup()
            
            var downloadValidator = DownloadValidator(snapshot: nil, snapshotDocuments: snapshot, error: error)
            
            do {
                let validDocumentCollection = try downloadValidator.validateCollection()
                
                validDataArray = try downloadValidator.serializeCollectionIntoDataArray(validDataDictionaryArray: validDocumentCollection)
            } catch {
                print(error.localizedDescription)
            }
            
            for item in validDataArray {
                let objectToParse = AnyParsedObject<UserAPIResponse>()
                
                guard let parsedData = try? objectToParse.parseObject(item) else {
                    return
                }
                
                parsedUsers.append(parsedData)
            }
            
            self.delegate?.didAttemptRawCollectionDownload(collection: parsedUsers, error: nil)
            
            for user in parsedUsers {
                myDispatchGroup.enter()
                
                self.fetchFullUser(user: user) { user in
                    defer { myDispatchGroup.leave() }
                    
                    fullUserCollection.append(user)
                }
            }
            
            myDispatchGroup.notify(queue: .main) {
                self.delegate?.didAttemptFullCollectionDownload(collection: fullUserCollection, error: nil)
            }
        }
    }
    
    func fetchFullUser(user: UserAPIResponse, completion: @escaping (_ user: User) -> Void) {
        guard let userId = user.id else {
            print(#file, #function, #line)
            return
        }
        
        let imageChildRef = storageRef.child("\(FirebaseParameter.publicUsers)\(userId)\(MediaExtensions.jpg)")
        
        imageChildRef.getData(maxSize: 10*1024*1024) { imageData, error in
            
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
            
            guard let fullUser = self.mapRawUserIntoFullUser(rawUser: user, userImage: image) else {
                return
            }
            
            completion(fullUser)
        }
    }
    
    func mapRawUserIntoFullUser(rawUser: UserAPIResponse, userImage: UIImage) -> User? {
        
        guard let id = rawUser.id, let bio = rawUser.bio, let username = rawUser.username, let signUpDate = rawUser.signUpDate, let userNumber = rawUser.userNumber else {
            return nil
        }
        
        let fullUser = User(id: id,
                            profileImage: userImage,
                            bio: bio,
                            username: username,
                            signUpDate: signUpDate,
                            userNumber: userNumber)
        
        return fullUser
    }
    
    func downloadIndividualUser(_ userId: String?, userType: ContentCollection) {
        guard let userId = userId else {
            return
        }
        
        db.collection(FirebaseParameter.privateUsers).document(userId).getDocument { snapshot, error in
            var downloadValidator = DownloadValidator(snapshot: snapshot, snapshotDocuments: nil, error: error)
            
            var parseableData = Data()
            
            do {
                let validDocument = try downloadValidator.validateDocument()
                
                parseableData = try downloadValidator.serializeDocumentIntoData(validDataDictionary: validDocument)
            } catch {
                print(error.localizedDescription)
            }
            
            let objectToParse = AnyParsedObject<UserAPIResponse>()
            
            guard let parsedData = try? objectToParse.parseObject(parseableData) else {
                return
            }
            
            self.delegate?.didAttemptRawUserDownload(rawUser: parsedData, error: nil)
            
            self.fetchFullUser(user: parsedData) { user in
                self.delegate?.didAttemptFullUserDownload(fullUser: user, error: nil)
            }
        }
    }
}

protocol UserDownloadDelegate: AnyObject {
    func didAttemptRawCollectionDownload(collection: [UserAPIResponse], error: String?)
    
    func didAttemptFullCollectionDownload(collection: [User], error: String?)
    
    func didAttemptRawUserDownload(rawUser: UserAPIResponse, error: String?)
    
    func didAttemptFullUserDownload(fullUser: User, error: String?)
}
extension UserDownloadDelegate {
    func didAttemptRawCollectionDownload(collection: [UserAPIResponse], error: String?) {
        print("default implementation")
    }
    
    func didAttemptFullCollectionDownload(collection: [User], error: String?) {
        print("default implementation")
    }
    
    func didAttemptRawUserDownload(rawUser: UserAPIResponse, error: String?) {
        print("default implementation")
    }
    
    func didAttemptFullUserDownload(fullUser: User, error: String?) {
        print("default implementation")
    }
}
