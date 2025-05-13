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
    
//    public func insert(_ shows: [LocalShow], timestamp: Date) async throws {
//        try await context.perform { [context] in
//            let managedCache = ManagedCache(context: context)
//            managedCache.timestamp = timestamp
//            managedCache.shows = ManagedShow.fetchShows(from: shows, in: context)
//            try context.save()
//        }
//    }
    
    public func insert(_ shows: [LocalShow], timestamp: Date) async throws {
        try await context.perform { [context] in
            let managedCache = try ManagedCache.find(in: context) ?? ManagedCache(context: context)
            managedCache.timestamp = timestamp
            let newManagedShows = ManagedShow.fetchShows(from: shows, in: context)
            let mutableShows = NSMutableOrderedSet(orderedSet: managedCache.shows)
            mutableShows.addObjects(from: newManagedShows.array)
            managedCache.shows = mutableShows

            try context.save()
        }
    }
    
    public func deleteCache() async throws {
        try await context.perform { [context] in
            try ManagedCache.deleteCache(in: context)
        }
    }
    
    public func insertFavorite(for showId: Int) async throws {
        try await context.perform { [context] in
            let managedShow = try ManagedShow.find(with: showId, in: context)
            managedShow?.isFavorite.toggle()
            try context.save()
        }
    }
}
