//
//  ShowsMapper.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import Foundation

public final class ShowsMapper {
    
    private struct Root: Decodable {
        let id: Int
        let name: String
        let image: ImageDecodable
        let genres: [String]
        let summary: String
        let schedule: Schedule

        struct ImageDecodable: Decodable {
            let medium, original: URL
        }
        
        // MARK: - Schedule
        struct Schedule: Decodable {
            let time: String?
            let days: [Day]
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Show] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let rootArray = try JSONDecoder().decode([Root].self, from: data)
            let shows = rootArray.map { Show(id: $0.id,
                                             name: $0.name,
                                             imageURL: $0.image.medium,
                                             schedule: mapSchedule(with: $0.schedule.time ?? "", and: $0.schedule.days),
                                             genres: "\($0.genres.joined(separator: ", "))",
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
