//
//  ShowsEndpoint.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import Foundation

public enum ShowsEndpoint {
    case getShows(page: Int)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getShows(page):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/shows"
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
            ].compactMap { $0 }
            return components.url!
        }
    }
}
