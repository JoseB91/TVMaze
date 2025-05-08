//
//  APIHelpers.swift
//  TVMazeTests
//
//  Created by José Briones on 8/5/25.
//

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension String {
    func makeJSON() -> Data {
        return self.data(using: .utf8)!
    }
}
