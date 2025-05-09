//
//  People.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

public struct Person: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let imageURL: URL?
    
    public init(id: Int, name: String, imageURL: URL?) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
}
