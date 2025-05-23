//
//  PeopleEndpointTests.swift
//  TVMazeTests
//
//  Created by José Briones on 11/5/25.
//

import XCTest
import TVMaze

class PeopleEndpointTests: XCTestCase {
    
    func test_people_endpointURL() {
        // Arrange
        let baseURL = URL(string: "https://api.tvmaze.com/")!
        
        // Act
        let received = PeopleEndpoint.getPeople(page: 1).url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.tvmaze.com", "host")
        XCTAssertEqual(received.path, "/people", "path")
        XCTAssertEqual(received.query?.contains("page=1"), true)
    }
}
