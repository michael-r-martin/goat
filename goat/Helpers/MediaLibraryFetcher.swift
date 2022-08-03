//
//  MediaLibraryFetcher.swift
//  goat
//
//  Created by Michael Martin on 03/08/2022.
//

import Foundation
import Photos
import UIKit

class MediaLibraryFetcher {
    
    weak var delegate: MediaLibraryFetchDelegate?
    
    func requestAuthorization(completion: @escaping (_ authorized: Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { authStatus in
            switch authStatus {
            case .authorized:
                completion(true)
            case .limited:
                completion(true)
            case .notDetermined, .denied, .restricted:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }
    
    func fetchPhotos() {
        var fetchedImages: [UIImage] = []
        
        let photoManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .fastFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 500
        
        let results = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if results.count < 1 {
            // no results
            return
        }
        
        for i in 0..<results.count {
            let asset = results.object(at: i)
            
            let size = CGSize(width: 700, height: 700)
            
            photoManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, _ in
                
                if let image = image {
                    fetchedImages.append(image)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.didAttemptImageFetch(images: fetchedImages, error: nil)
                }
            }
        }
    }
}

protocol MediaLibraryFetchDelegate: AnyObject {
    func didAttemptImageFetch(images: [UIImage], error: String?)
}
