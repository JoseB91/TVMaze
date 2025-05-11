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
        let schedule: ScheduleDecodable
        let rating: RatingDecodable
        
        struct ImageDecodable: Decodable {
            let medium, original: URL
        }
        
        struct ScheduleDecodable: Decodable {
            let time: String?
            let days: [Day]
        }
        
        struct RatingDecodable: Decodable {
            let average: Double?
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
                                             genres: mapGenres(with: $0.genres),
                                             summary: $0.summary.removeHTMLTags(),
                                             rating: getRatingString(from: $0.rating.average),
                                             isFavorite: false) }
            return shows
        } catch {
            throw error
        }
    }
    
    public static func mapPersonShow(_ data: Data, from response: HTTPURLResponse) throws -> Show {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            let show = Show(id: root.id,
                            name: root.name,
                            imageURL: root.image.medium,
                            schedule: mapSchedule(with: root.schedule.time ?? "", and: root.schedule.days),
                            genres: mapGenres(with: root.genres),
                            summary: root.summary.removeHTMLTags(),
                            rating: getRatingString(from: root.rating.average),
                            isFavorite: false)
            return show
        } catch {
            throw error
        }
    }
    
    private static func mapSchedule(with time: String, and days: [Day]) -> String {
        let stringDays = days.map { $0.rawValue }.joined(separator: ", ")
        if stringDays == "Monday, Tuesday, Wednesday, Thursday, Friday" {
            return "Weekdays at \(time)"
        } else if stringDays == "Monday, Tuesday, Wednesday, Thursday" {
            return "Mondays to Thursdays at \(time)"
        } else if stringDays == "" {
            return ""
        } else {
            return "\(stringDays)s at \(time)"
        }
    }
    
    private static func mapGenres(with genres: [String]) -> String {
        if genres.isEmpty {
            return ""
        } else {
            return "\(genres.joined(separator: " | "))"
        }
    }
    
    private static func getRatingString(from rating: Double?) -> String {
        guard let rating = rating else {
            return ""
        }
        return rating.toStringWithOneDecimal()
    }
}
