//
//  Enums.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

enum Day: String, Codable {
    case friday = "Friday"
    case monday = "Monday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    case thursday = "Thursday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
}

public enum MapperError: Error {
    case unsuccessfullyResponse
}
