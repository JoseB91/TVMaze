//
//  ShowsMapperTests.swift
//  TVMazeTests
//
//  Created by José Briones on 8/5/25.
//

import XCTest
@testable import TVMaze

final class ShowsMapperTests: XCTestCase {
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = MockShowsViewModel.mockShow()
        let jsonString = "[{\"id\":250,\"url\":\"https://www.tvmaze.com/shows/250/kirby-buckets\",\"name\":\"Kirby Buckets\",\"type\":\"Scripted\",\"language\":\"English\",\"genres\":[\"Comedy\"],\"status\":\"Ended\",\"runtime\":30,\"averageRuntime\":30,\"premiered\":\"2014-10-20\",\"ended\":\"2017-02-02\",\"officialSite\":\"http://disneyxd.disney.com/kirby-buckets\",\"schedule\":{\"time\":\"07:00\",\"days\":[\"Monday\",\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\"]},\"rating\":{\"average\":null},\"weight\":63,\"network\":{\"id\":25,\"name\":\"Disney XD\",\"country\":{\"name\":\"United States\",\"code\":\"US\",\"timezone\":\"America/New_York\"},\"officialSite\":null},\"webChannel\":{\"id\":83,\"name\":\"DisneyNOW\",\"country\":{\"name\":\"United States\",\"code\":\"US\",\"timezone\":\"America/New_York\"},\"officialSite\":\"https://disneynow.com/\"},\"dvdCountry\":null,\"externals\":{\"tvrage\":37394,\"thetvdb\":278449,\"imdb\":\"tt3544772\"},\"image\":{\"medium\":\"https://static.tvmaze.com/uploads/images/medium_portrait/1/4600.jpg\",\"original\":\"https://static.tvmaze.com/uploads/images/original_untouched/1/4600.jpg\"},\"summary\":\"<p>The single-camera series that mixes live-action and animation stars Jacob Bertrand as the title character. <b>Kirby Buckets</b> introduces viewers to the vivid imagination of charismatic 13-year-old Kirby Buckets, who dreams of becoming a famous animator like his idol, Mac MacCallister. With his two best friends, Fish and Eli, by his side, Kirby navigates his eccentric town of Forest Hills where the trio usually find themselves trying to get out of a predicament before Kirby's sister, Dawn, and her best friend, Belinda, catch them. Along the way, Kirby is joined by his animated characters, each with their own vibrant personality that only he and viewers can see.</p>\",\"updated\":1704795334,\"_links\":{\"self\":{\"href\":\"https://api.tvmaze.com/shows/250\"},\"previousepisode\":{\"href\":\"https://api.tvmaze.com/episodes/1051658\",\"name\":\"Yep, Still Happening\"}}}]"
        
        let json = jsonString.makeJSON()
        
        // Act
        let result = try ShowsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
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
                try ShowsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)
        
        // Assert
        XCTAssertThrowsError(
            // Act
            try ShowsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
}
