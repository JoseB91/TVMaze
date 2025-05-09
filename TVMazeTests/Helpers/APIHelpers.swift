//
//  APIHelpers.swift
//  TVMazeTests
//
//  Created by José Briones on 8/5/25.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

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
