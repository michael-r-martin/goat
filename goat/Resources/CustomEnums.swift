//
//  CustomEnums.swift
//  goat
//
//  Created by Michael Martin on 30/07/2022.
//

import Foundation

enum ContentCollection: String {
    case publicUserProfile = "publicUsers"
    case imagePosts = "imagePosts"
    case privateUserProfile = "privateUsers"
}

enum DownloadStatus {
    case rawContentFetched
    case rawCollectionFetched
    case imageFetched
    case allImagesFetched
}
