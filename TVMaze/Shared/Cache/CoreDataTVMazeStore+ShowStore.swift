//
//  CoreDataTVMazeStore+ShowsStore.swift
//  TVMaze
//
//  Created by José Briones on 10/5/25.
//

import CoreData

extension CoreDataTVMazeStore: ShowsStore {
    
    public func retrieve() async throws -> CachedShows? {
        try await context.perform { [context] in
            try ManagedCache.find(in: context).map {
                CachedShows(shows: $0.localShows, timestamp: $0.timestamp)
            }
        }
    }
    
    public func insert(_ shows: [LocalShow], timestamp: Date) async throws {
        try await context.perform { [context] in
            if try !ManagedCache.cacheExists(in: context) {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.shows = ManagedShow.fetchShows(from: shows, in: context)
                try context.save()
            }
        }
    }
    
    public func deleteCache() async throws {
        try await context.perform { [context] in
            try ManagedCache.deleteCache(in: context)
        }
    }
}
