//
//  UserModels.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation
import UIKit

struct PublicUserAPIResponse: Codable {
    var id: String?
    var profileImageUrl: String?
    var bio: String?
    var username: String?
    var signUpDate: String?
    var userNumber: Int?
}

struct PublicUser {
    var id: String?
    var profileImage: UIImage
    var bio: String?
    var username: String?
    var signUpDate: String?
    var userNumber: Int?
}

struct PrivateUserAPIResponse: Codable {
    var id: String?
    var profileImageUrl: String?
    var bio: String?
    var username: String?
    var signUpDate: String?
    var userNumber: Int?
    var email: String?
}

struct PrivateUser {
    var id: String?
    var profileImage: UIImage
    var bio: String?
    var username: String?
    var signUpDate: String?
    var userNumber: Int?
    var email: String
}
