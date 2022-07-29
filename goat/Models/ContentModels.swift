//
//  ContentModels.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation
import UIKit

struct FeedPostAPIResponse: Codable {
    var id: String?
    var userImageUrl: String?
    var contentImageUrl: String?
    var contentDescription: String?
    var username: String?
    var timestamp: Double?
}

struct FeedPost {
    var id: String
    var userImage: UIImage
    var contentImage: UIImage
    var contentDescription: String
    var username: String
    var timestamp: Double
    @DisplayTime var timeAgo: Double
}

// Can i use coding keys to map one struct to another?
