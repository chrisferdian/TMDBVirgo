//
//  ContentSection.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 19/05/22.
//

import UIKit

typealias ContentDataSource = UICollectionViewDiffableDataSource<ContentSection, AnyHashable>
typealias ContentSnapshot = NSDiffableDataSourceSnapshot<ContentSection, AnyHashable>
enum ContentSection {
    case header
    case trending
    case discover
    
    var sectionTitle: String? {
        switch self {
        case .trending: return "Trending"
        case .discover: return "Discover"
        default: return nil
        }
    }
}

typealias DetailDataSource = UICollectionViewDiffableDataSource<DetailSection, AnyHashable>
typealias DetailSnapshot = NSDiffableDataSourceSnapshot<DetailSection, AnyHashable>

enum DetailSection {
    case header
    case vote
    case overview
    case releaseDate
    case reviews

    var title: String? {
        switch self {
        case .overview: return "Overview"
        case .releaseDate: return "Release date"
        case .reviews: return "Reviews"
        default: return nil
        }
    }
}
