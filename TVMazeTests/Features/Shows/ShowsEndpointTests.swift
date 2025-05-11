//
//  ShowsEndpointTests.swift
//  TVMazeTests
//
//  Created by José Briones on 8/5/25.
//

import XCTest
import TVMaze

class ShowsEndpointTests: XCTestCase {

    func test_shows_endpointURL() {
        // Arrange
        let baseURL = URL(string: "https://api.tvmaze.com/")!
        
        // Act
        let received = ShowsEndpoint.getShows(page: 1).url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.tvmaze.com", "host")
        XCTAssertEqual(received.path, "/shows", "path")
        XCTAssertEqual(received.query?.contains("page=1"), true)
    }
}
