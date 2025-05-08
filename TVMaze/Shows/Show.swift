//
//  Show.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

public struct Show: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let imageURL: URL

    public init(id: Int, name: String, imageURL: URL) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
}
