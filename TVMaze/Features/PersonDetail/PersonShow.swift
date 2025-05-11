//
//  PersonShow.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

public struct PersonShow: Identifiable, Hashable {
    public var id: String
    public let name: String
    public let showURL: URL
    
    public init(name: String, showURL: URL) {
        self.name = name
        self.showURL = showURL
        self.id = showURL.absoluteString
    }
}
