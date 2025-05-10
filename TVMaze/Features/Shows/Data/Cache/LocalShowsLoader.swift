//
//  LocalShowsLoader.swift
//  TVMaze
//
//  Created by José Briones on 10/5/25.
//

import Foundation

public final class LocalShowsLoader {
    private let store: ShowsStore
    private let currentDate: () -> Date
        
    public init(store: ShowsStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public protocol ShowCache {
    func save(_ shows: [Show]) async throws
}

extension LocalShowsLoader: ShowCache {
    public func save(_ shows: [Show]) async throws {
        do {
            try await store.deleteCache()
            try await store.insert(shows.toLocal(), timestamp: currentDate())
        } catch {
            try await store.deleteCache()
        }
    }
}

extension LocalShowsLoader {
    private struct FailedLoad: Error {}
    
    public func load() async throws -> [Show] {
        if let cache = try await store.retrieve(), CachePolicy.validate(cache.timestamp, against: currentDate()) {
            return cache.shows.toModels()
        } else {
            throw FailedLoad()
        }
    }
}

extension LocalShowsLoader {
    private struct InvalidCache: Error {}
    
    public func validateCache() async throws {
        do {
            if let cache = try await store.retrieve(),
                !CachePolicy.validate(cache.timestamp,
                                      against: currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try await store.deleteCache()
        }
    }
}

extension Array where Element == Show {
    public func toLocal() -> [LocalShow] {
        return map { LocalShow(id: $0.id,
                               name: $0.name,
                               imageURL: $0.imageURL,
                               schedule: $0.schedule,
                               genres: $0.genres,
                               summary: $0.summary)}
    }
}

private extension Array where Element == LocalShow {
    func toModels() -> [Show] {
        return map { Show(id: $0.id,
                          name: $0.name,
                          imageURL: $0.imageURL,
                          schedule: $0.schedule,
                          genres: $0.genres,
                          summary: $0.summary)
        }
    }
}
