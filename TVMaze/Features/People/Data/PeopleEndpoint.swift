//
//  PeopleEndpoint.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

public enum PeopleEndpoint {
    case getPeople(page: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getPeople(page):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "people"
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
            ].compactMap { $0 }
            return components.url!
        }
    }
}
