//
//  ShowsMapper.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

public final class ShowsMapper {
    
    private struct Root: Decodable {
        let id: Int
        let name: String
        let image: ImageDecodable
        
        private struct ImageDecodable: Decodable {
            let medium, original: URL
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Show] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let rootArray = try JSONDecoder().decode([Root].self, from: data)
            return {
                rootArray.map { Show(id: $0.id,
                                 name: $0.name,
                                 imageURL: $0.image.medium) }
            }
        } catch {
            throw error
        }
    }
}

//TODO: Organize better this code below
extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

public enum MapperError: Error {
    case unsuccessfullyResponse
}

