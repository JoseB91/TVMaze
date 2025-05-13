//
//  Episode.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

public struct Episode: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let imageURL: URL?
    public let season: Int
    public let number: Int
    public let summary: String
    
    public init(id: Int, name: String, imageURL: URL?, season: Int, number:  Int, summary: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.season = season
        self.number = number
        self.summary = summary
    }
}
