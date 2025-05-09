//
//  Extensions.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

extension String {
    func removeHTMLTags() -> String {
        return self.replacingOccurrences(of: "<p>", with: "")
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "<i>", with: "")
            .replacingOccurrences(of: "</p>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "</i>", with: "")
    }
}
