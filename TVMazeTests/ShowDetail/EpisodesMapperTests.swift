//
//  EpisodesMapperTests.swift
//  TVMazeTests
//
//  Created by José Briones on 9/5/25.
//

import XCTest
import TVMaze

final class EpisodesMapperTests: XCTestCase {
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = mockEpisode()
        let jsonString = "[{\"id\":20849,\"url\":\"https://www.tvmaze.com/episodes/20849/kirby-buckets-1x01-cars-buses-and-lawnmowers\",\"name\":\"Cars, Buses and Lawnmowers\",\"season\":1,\"number\":1,\"type\":\"regular\",\"airdate\":\"2014-10-20\",\"airtime\":\"20:00\",\"airstamp\":\"2014-10-21T00:00:00+00:00\",\"runtime\":30,\"rating\":{\"average\":null},\"image\":{\"medium\":\"https://static.tvmaze.com/uploads/images/medium_landscape/303/759608.jpg\",\"original\":\"https://static.tvmaze.com/uploads/images/original_untouched/303/759608.jpg\"},\"summary\":\"<p>Kirby learns about a character design contest featuring the ultimate prize - a chance to meet idol Mac McCallister and debut an animated character on TV. He plans to attend with Fish and Eli, but when they unexpectedly get stranded at school hours before the contest, they devise a plan that accidently places them in the middle of \\\"Clown Town,\\\" an abandoned area of the city where creepy clowns reign. Meanwhile, Dawn realizes Kirby is using an embarrassing drawing of her titled \\\"Dawnzilla\\\" as his submission for the contest, so she and Belinda do everything in their power to stop him.</p>\",\"_links\":{\"self\":{\"href\":\"https://api.tvmaze.com/episodes/20849\"},\"show\":{\"href\":\"https://api.tvmaze.com/shows/250\",\"name\":\"Kirby Buckets\"}}}]"
        
        let json = jsonString.makeJSON()
        
        // Act
        let result = try EpisodesMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
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
                try EpisodesMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)

        // Assert
        XCTAssertThrowsError(
            // Act
            try EpisodesMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    // MARK: - Helpers

    private func mockEpisode() -> Episode {
        Episode(id: 20849,
                name: "Cars, Buses and Lawnmowers",
                imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_landscape/303/759608.jpg")!,
                season: 1,
                number: 1,
                summary: "Kirby learns about a character design contest featuring the ultimate prize - a chance to meet idol Mac McCallister and debut an animated character on TV. He plans to attend with Fish and Eli, but when they unexpectedly get stranded at school hours before the contest, they devise a plan that accidently places them in the middle of \"Clown Town,\" an abandoned area of the city where creepy clowns reign. Meanwhile, Dawn realizes Kirby is using an embarrassing drawing of her titled \"Dawnzilla\" as his submission for the contest, so she and Belinda do everything in their power to stop him.")
    }
}
