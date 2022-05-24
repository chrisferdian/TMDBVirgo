//
//  TMDBResult.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 22/05/22.
//

import Foundation
// MARK: - Result
struct TMDBReviewResult: Codable {
    let author: String?
    let authorDetails: TMDBReviewAuthorDetails?
    let content, createdAt, id, updatedAt: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}
