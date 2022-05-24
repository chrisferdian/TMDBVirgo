//
//  TMDBReviewAuthorDetails.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 22/05/22.
//

import Foundation
struct TMDBReviewAuthorDetails: Codable {
    let name, username, avatarPath: String?
        let rating: Int?

        enum CodingKeys: String, CodingKey {
            case name, username
            case avatarPath = "avatar_path"
            case rating
        }
}
