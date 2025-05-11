//
//  ShowsStore.swift
//  TVMaze
//
//  Created by José Briones on 10/5/25.
//

import Foundation

public typealias CachedShows = (shows: [LocalShow], timestamp: Date)
    
public protocol ShowsStore {
    func deleteCache() async throws
    func insert(_ shows: [LocalShow], timestamp: Date) async throws
    func retrieve() async throws -> CachedShows?
    func insertFavorite(for showId: Int) async throws
}
