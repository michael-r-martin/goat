//
//  ContentModels.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation
import UIKit

struct ImagePostAPIResponse: Codable {
    var postId: String?
    var userId: String?
    var contentDescription: String?
    var username: String?
    var timestamp: Double?
}

struct ImagePost {
    var postId: String
    var userId: String
    var userImage: UIImage
    var contentImage: UIImage
    var contentDescription: String
    var username: String
    var timestamp: Double
    @DisplayTime var timeAgo: Double
}
