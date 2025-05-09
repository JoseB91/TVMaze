//
//  PersonShowsMapper.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

public final class PersonShowsMapper {
    
    private struct Root: Decodable {
        let links: Links

        enum CodingKeys: String, CodingKey {
            case links = "_links"
        }
        
        struct Links: Decodable {
            let show, character: LinkDecodable
            
            struct LinkDecodable: Decodable {
                let href: URL
                let name: String
            }
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [PersonShow] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let rootArray = try JSONDecoder().decode([Root].self, from: data)
            let personShows = rootArray.map { PersonShow(name: $0.links.show.name,
                                                         showURL: $0.links.show.href) }
            return personShows
        } catch {
            throw error
        }
    }
}
