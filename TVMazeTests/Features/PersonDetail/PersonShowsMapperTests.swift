//
//  PersonShowsMapperTests.swift
//  TVMazeTests
//
//  Created by José Briones on 11/5/25.
//

import XCTest
@testable import TVMaze

final class PersonShowsMapperTests: XCTestCase {
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = MockPersonDetailViewModel.mockPersonShow()
        let jsonString = "[{\"self\":false,\"voice\":false,\"_links\":{\"show\":{\"href\":\"https://api.tvmaze.com/shows/1\",\"name\":\"Under the Dome\"},\"character\":{\"href\":\"https://api.tvmaze.com/characters/1\",\"name\":\"Dale \\\"Barbie\\\" Barbara\"}}}]"
        
        let json = jsonString.makeJSON()
        
        // Act
        let result = try PersonShowsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange
        let json = "".makeJSON()
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            // Assert
            XCTAssertThrowsError(
                // Act
                try PersonShowsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)
        
        // Assert
        XCTAssertThrowsError(
            // Act
            try PersonShowsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
}
