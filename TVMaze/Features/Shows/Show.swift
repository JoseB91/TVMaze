//
//  Show.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import Foundation

public struct Show: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let imageURL: URL
    public let schedule: String
    public let genres: String
    public let summary: String
    public let rating: String
    
    public init(id: Int, name: String, imageURL: URL, schedule: String, genres:  String, summary: String, rating: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.schedule = schedule
        self.genres = genres
        self.summary = summary
        self.rating = rating
    }
}
