//
//  EpisodesMapper.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import Foundation

public final class EpisodesMapper {
    
    private struct Root: Decodable {
        let id: Int
        let name: String
        let season, number: Int
        let image: ImageDecodable?
        let summary: String
        
        struct ImageDecodable: Decodable {
            let medium, original: URL?
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Episode] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let rootArray = try JSONDecoder().decode([Root].self, from: data)
            let shows = rootArray.map { Episode(id: $0.id,
                                                name: $0.name,
                                                imageURL: $0.image?.medium,
                                                season: $0.season,
                                                number: $0.number,
                                                summary: $0.summary.removeHTMLTags()) }
            return shows
        } catch {
            throw error
        }
    }
    
    private static func mapSchedule(with time: String, and days: [Day]) -> String {
        let stringDays = days.map { $0.rawValue }.joined(separator: ", ")
        return "Schedule: \(stringDays) at \(time)"
    }
}
