//
//  EpisodesEndpoint.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import Foundation

public enum EpisodesEndpoint {
    case getEpisodes(showId: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getEpisodes(showId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "shows/\(showId)/episodes"
            return components.url!
        }
    }
}
