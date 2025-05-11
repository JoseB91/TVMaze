//
//  LocalShow.swift
//  TVMaze
//
//  Created by José Briones on 10/5/25.
//

import Foundation

public struct LocalShow: Equatable {
    public let id: Int
    public let name: String
    public let imageURL: URL
    public let schedule: String
    public let genres: String
    public let summary: String
    public let rating: String
    public let isFavorite: Bool
    
    public init(id: Int, name: String, imageURL: URL, schedule: String, genres: String, summary: String, rating: String, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.schedule = schedule
        self.genres = genres
        self.summary = summary
        self.rating = rating
        self.isFavorite = isFavorite
    }
}
