//
//  TMDBReviewReview.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 22/05/22.
//

import Foundation
struct TMDBReviewResonse: Codable {
    let id, page: Int?
    let results: [TMDBReviewResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
