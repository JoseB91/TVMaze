//
//  EpisodesEndpointTests.swift
//  TVMazeTests
//
//  Created by José Briones on 9/5/25.
//

import XCTest
import TVMaze

class EpisodesEndpointTests: XCTestCase {
    
    func test_episodes_endpointURL() {
        // Arrange
        let baseURL = URL(string: "https://api.tvmaze.com/")!
        
        // Act
        let received = EpisodesEndpoint.getEpisodes(showId: 250).url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.tvmaze.com", "host")
        XCTAssertEqual(received.path, "/shows/250/episodes", "path")
    }
}
