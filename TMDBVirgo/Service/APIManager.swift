//
//  APIManager.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 21/05/22.
//

import Combine
import UIKit

struct APIManager {
    func getTvOnAir() -> AnyPublisher<TMDBResonse, Error> {
        return fetch(endpoint: .getTvOnTheAir)
    }
    func getNowPlaying() -> AnyPublisher<TMDBResonse, Error> {
        return fetch(endpoint: .getNowPlaying)
    }
    func getDiscover(type: String) -> AnyPublisher<TMDBResonse, Error> {
        return fetch(endpoint: .getDiscover(type: type))
    }
    func getTrending(type: String) -> AnyPublisher<TMDBResonse, Error> {
        return fetch(endpoint: .getTrending(type: type))
    }
    func getReviews(type: String, id: Int) -> AnyPublisher<TMDBReviewResonse, Error> {
        return fetch(endpoint: .getReviews(id: id))
    }
    private func fetch<Output: Codable>(endpoint: MainRouter) -> AnyPublisher<Output, Error> {
        do {
            let request = try endpoint.request()
            return URLSession.shared.dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                .map { $0.data }
                .decode(type: Output.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } catch (let err) {
            print(err.localizedDescription)
            return Fail(error: ErrorType.parseUrlFail).eraseToAnyPublisher()
        }
    }
}
