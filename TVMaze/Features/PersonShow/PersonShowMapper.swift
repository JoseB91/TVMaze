//
//  PersonShowMapper.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

public final class PersonShowMapper {
    
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
        
        struct Schedule: Decodable {
            let time: String?
            let days: [Day]
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Show {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            let show = Show(id: root.id,
                            name: root.name,
                            imageURL: root.image.medium,
                            schedule: mapSchedule(with: root.schedule.time ?? "", and: root.schedule.days),
                            genres: "\(root.genres.joined(separator: ", "))",
                            summary: root.summary.removeHTMLTags())
            return show
        } catch {
            throw error
        }
    }
    
    private static func mapSchedule(with time: String, and days: [Day]) -> String {
        let stringDays = days.map { $0.rawValue }.joined(separator: ", ")
        if stringDays == "Monday, Tuesday, Wednesday, Thursday, Friday" {
            return "Schedule: Weekdays at \(time)"
        } else if stringDays == "Monday, Tuesday, Wednesday, Thursday" {
            return "Schedule: Monday to Thursday at \(time)"
        } else {
            return "Schedule: \(stringDays)s at \(time)"
        }
    }
}
