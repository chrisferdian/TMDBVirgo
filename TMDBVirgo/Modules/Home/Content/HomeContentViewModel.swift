//
//  HomeContentViewModel.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 19/05/22.
//

import UIKit
import Combine

protocol HomeContentDelegate: AnyObject {
    func didReceive(populars: [HomeContentModel])
    func didReceive(discover: [HomeContentModel])
    func didReceive(playing: [HomeContentModel])
}

class HomeContentViewModel {
    private var cancellable: [AnyCancellable] = []
    private var popularMovies: [HomeContentModel] = [] {
        didSet {
            print("POPULAR: --> \(popularMovies.count)")
            self.delegate?.didReceive(populars: popularMovies)
        }
    }
    private var discoverMovies: [HomeContentModel] = [] {
        didSet {
            print("DISCOVER MOVIES: --> \(discoverMovies.count)")
            self.delegate?.didReceive(discover: discoverMovies)
        }
    }
    private var nowPlayingMovies: [HomeContentModel] = [] {
        didSet {
            print("NOW PLAYING: --> \(nowPlayingMovies.count)")
            self.delegate?.didReceive(playing: nowPlayingMovies)
        }
    }
    var delegate: HomeContentDelegate?
    
    func fetchTrending(type: String) {
        APIManager().getTrending(type: type)
            .map { _response in
                _response.results.map({ HomeContentModel(result: $0) })
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .assign(to: \.popularMovies, on: self)
            .store(in: &self.cancellable)
    }
    
    func fetchDiscover(type: String) {
        APIManager().getDiscover(type: type)
            .map { _response in
                _response.results.map({ HomeContentModel(result: $0) })
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .assign(to: \.discoverMovies, on: self)
            .store(in: &self.cancellable)
    }
    
    func fetchNowPlaying() {
        APIManager().getNowPlaying()
            .map { _response in
                _response.results.map({ HomeContentModel(result: $0) })
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .assign(to: \.nowPlayingMovies, on: self)
            .store(in: &self.cancellable)
    }
    
    func fetchTvOnAir() {
        APIManager().getTvOnAir()
            .map { _response in
                _response.results.map({ HomeContentModel(result: $0) })
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .assign(to: \.nowPlayingMovies, on: self)
            .store(in: &self.cancellable)
    }
}
