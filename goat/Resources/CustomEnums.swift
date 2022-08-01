//
//  CustomEnums.swift
//  goat
//
//  Created by Michael Martin on 30/07/2022.
//

import Foundation
import FirebaseFirestore

enum ContentCollection {
    case publicUserProfile(String?)
    case privateUserProfile(String?)
    case userImages(String?)
    case newsFeed(String?)
}

enum DownloadStatus {
    case rawContentFetched
    case rawCollectionFetched
    case imageFetched
    case allImagesFetched
}

enum MediaExtensions: String {
    case jpg = ".jpg"
    case mov = ".mov"
}
