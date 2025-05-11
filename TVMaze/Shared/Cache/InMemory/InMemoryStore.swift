//
//  InMemoryStore.swift
//  TVMaze
//
//  Created by José Briones on 10/5/25.
//

import Foundation

public class InMemoryStore {
    private var showsCache: CachedShows?
    
    public init() {}
}

extension InMemoryStore: ShowsStore {
    public func deleteCache() throws {
        showsCache = nil
    }

    public func insert(_ shows: [LocalShow], timestamp: Date) throws {
        if showsCache == nil {
            showsCache = CachedShows(shows: shows, timestamp: timestamp)
        }
    }

    public func retrieve() throws -> CachedShows? {
        showsCache
    }
    
    public func insertFavorite(for showId: Int) async throws {
    }
}
