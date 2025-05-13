//
//  ShowStoreSpy.swift
//  TVMazeTests
//
//  Created by José Briones on 13/5/25.
//

import Foundation
import TVMaze

public class ShowsStoreSpy: ShowsStore {
    enum ReceivedMessage: Equatable {
        case delete
        case insert([LocalShow], Date)
        case retrieve
        case insertFavorite(Int)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedShows?, Error>?
    private var favoriteInsertionResult: Result<Void, Error>?

    // MARK: Delete
    public func deleteCache() async throws {
        receivedMessages.append(.delete)
        try deletionResult?.get()
    }

    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }

    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }
    
    // MARK: Insert
    public func insert(_ shows: [LocalShow], timestamp: Date) async throws {
        receivedMessages.append(.insert(shows, timestamp))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    // MARK: Retrieve
    public func retrieve() async throws -> CachedShows? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithExpiredCache(with shows: [LocalShow], timestamp: Date, error: Error) {
        retrievalResult = .failure(error)
    }

    func completeRetrieval(with shows: [LocalShow], timestamp: Date) {
        retrievalResult = .success(CachedShows(shows: shows, timestamp: timestamp))
    }
    
    // MARK: Insert Favorite
    public func insertFavorite(for showId: Int) async throws {
        receivedMessages.append(.insertFavorite(showId))
        try favoriteInsertionResult?.get()
    }
    
    func completeFavoriteInsertion(with error: Error) {
        favoriteInsertionResult = .failure(error)
    }
    
    func completeFavoriteInsertionSuccessfully() {
        favoriteInsertionResult = .success(())
    }

}
