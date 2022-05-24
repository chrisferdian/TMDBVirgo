// TMDBResonse.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tMDBResonse = try? newJSONDecoder().decode(TMDBResonse.self, from: jsonData)

import Foundation

// MARK: - TMDBResonse
struct TMDBResonse: Codable, Identifiable {
    var id: String = UUID().uuidString
    let page: Int?
    let results: [TMDBResult]
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
