//
//  PersonShowsEndpointTests.swift
//  TVMazeTests
//
//  Created by José Briones on 11/5/25.
//

import XCTest
import TVMaze

class PersonShowsEndpointTests: XCTestCase {
    
    func test_personShows_endpointURL() {
        // Arrange
        let baseURL = URL(string: "https://api.tvmaze.com/")!
        
        // Act
        let received = PersonShowsEndpoint.getPersonShows(personId: 1).url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.tvmaze.com", "host")
        XCTAssertEqual(received.path, "/people/1/castcredits", "path")
    }
}
