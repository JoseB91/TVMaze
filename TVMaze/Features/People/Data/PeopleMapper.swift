//
//  PeopleMapper.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

public final class PeopleMapper {
    
    private struct Root: Decodable {
        let id: Int
        let name: String
        let image: ImageDecodable? //TODO: Review if images and other data can be optional
        
        struct ImageDecodable: Decodable {
            let medium, original: URL
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Person] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let rootArray = try JSONDecoder().decode([Root].self, from: data)
            let people = rootArray.map { Person(id: $0.id,
                                                name: $0.name,
                                                imageURL: $0.image?.medium)}
            return people
        } catch {
            throw error
        }
    }
}
