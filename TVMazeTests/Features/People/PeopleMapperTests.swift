//
//  PeopleMapperTests.swift
//  TVMazeTests
//
//  Created by José Briones on 11/5/25.
//

import XCTest
import TVMaze

final class PeopleMapperTests: XCTestCase {
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = mockPerson()
        let jsonString = "[{\"id\":1,\"url\":\"https://www.tvmaze.com/people/1/mike-vogel\",\"name\":\"Mike Vogel\",\"country\":{\"name\":\"United States\",\"code\":\"US\",\"timezone\":\"America/New_York\"},\"birthday\":\"1979-07-17\",\"deathday\":null,\"gender\":\"Male\",\"image\":{\"medium\":\"https://static.tvmaze.com/uploads/images/medium_portrait/0/1815.jpg\",\"original\":\"https://static.tvmaze.com/uploads/images/original_untouched/0/1815.jpg\"},\"updated\":1732284645,\"_links\":{\"self\":{\"href\":\"https://api.tvmaze.com/people/1\"}}}]"


        let json = jsonString.makeJSON()
        
        // Act
        let result = try PeopleMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
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
                try PeopleMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)

        // Assert
        XCTAssertThrowsError(
            // Act
            try PeopleMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    // MARK: - Helpers

    private func mockPerson() -> Person {
        Person(id: 1,
               name: "Mike Vogel",
               imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/0/1815.jpg")!)
    }
}
