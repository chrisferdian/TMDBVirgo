//
//  MainRouter.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 19/05/22.
//

import Foundation
enum MainRouter {
    case getTrending(type: String)
    case getDiscover(type: String)
    case getNowPlaying
    case getTvOnTheAir
    case getReviews(id: Int)
    
    private static let baseURLString = "https://api.themoviedb.org/3"
    private static let apiKey = "a42b168856dcc7d96b4321bee09e82b3"
    
    private enum HTTPMethod {
        case get
        case post
        case put
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .delete: return "DELETE"
            }
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getTrending, .getDiscover, .getNowPlaying, .getTvOnTheAir, .getReviews: return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getTrending(let type):
            return "/trending/\(type)/week"
        case .getDiscover(let type):
            return "/discover/\(type)"
        case .getNowPlaying:
            return "/movie/now_playing"
        case .getTvOnTheAir:
            return "/tv/on_the_air"
        case .getReviews(let id):
            return "/movie/\(id)/reviews"
        }
    }
    
    private var parameters: [String: Any] {
        switch self {
        case .getTrending:
            return ["language": "en-US", "api_key": MainRouter.apiKey]
        case .getDiscover, .getTvOnTheAir, .getReviews:
            return ["page": 1, "language": "en-US", "api_key": MainRouter.apiKey]
        case .getNowPlaying:
            return ["language": "en-US", "api_key": MainRouter.apiKey]
        }
    }
    func request() throws -> URLRequest {
        let urlString = "\(MainRouter.baseURLString)\(path)"
        var components = URLComponents(string: urlString)!
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        guard let url = components.url else {
            throw ErrorType.parseUrlFail
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .getTrending, .getDiscover, .getNowPlaying, .getTvOnTheAir, .getReviews:
            return request
        }
    }
}

enum ErrorType: LocalizedError {
    case parseUrlFail
    case notFound
    case validationError
    case serverError
    case defaultError
    
    var errorDescription: String? {
        switch self {
        case .parseUrlFail:
            return "Cannot initial URL object."
        case .notFound:
            return "Not Found"
        case .validationError:
            return "Validation Errors"
        case .serverError:
            return "Internal Server Error"
        case .defaultError:
            return "Something went wrong."
        }
    }
}
