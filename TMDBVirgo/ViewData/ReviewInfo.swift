//
//  ReviewInfo.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 22/05/22.
//

import Foundation

struct ReviewInfo: Hashable {
    var content: String?
    var authorName: String?
    var authorAvatar: String?
    
    init(raw: TMDBReviewResult) {
        self.content = raw.content
        self.authorName = raw.author == nil ? "Unknown" : raw.author
        self.authorAvatar = raw.authorDetails?.avatarPath
    }
}
