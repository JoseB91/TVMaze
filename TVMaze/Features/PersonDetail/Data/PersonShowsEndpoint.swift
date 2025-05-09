//
//  PersonShowsEndpoint.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

public enum PersonShowsEndpoint {
    case getPersonShows(personId: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getPersonShows(personId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "people/\(personId)/castcredits"
            return components.url!
        }
    }
}
