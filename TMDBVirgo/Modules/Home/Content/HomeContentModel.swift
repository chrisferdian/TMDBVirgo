//
//  HomeContentModel.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 19/05/22.
//

struct HomeContentModel: Hashable {
    var id: Int?
    var imageUrl: String?
    var title: String?
    var backdrop: String?
    var vote: Double?
    var overview: String?
    var releaseDate: String?
    
    init(result: TMDBResult) {
        self.id = result.id
        self.backdrop = result.backdropPath
        self.imageUrl = result.posterPath
        self.title = result.title == nil ? result.name : result.title
        self.vote = result.voteAverage
        self.overview = result.overview
        self.releaseDate = result.releaseDate == nil ? result.firstAirDate : result.releaseDate
    }
}
