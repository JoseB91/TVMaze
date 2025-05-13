//
//  SaveShowsCacheTests.swift
//  TVMazeTests
//
//  Created by José Briones on 13/5/25.
//

import XCTest
import TVMaze

final class SaveShowsCacheTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        // Arrange
        let (_, store) = makeSUT()
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_deletesCacheOnInsertionError() async {
        // Arrange
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
            store.completeDeletionSuccessfully()
        })
    }
    
    func test_save_failsOnInsertionErrorAndDeletionError() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: anyNSError(), when: {
            store.completeInsertion(with: anyNSError())
            store.completeDeletion(with: anyNSError())
        })
    }
    
    func test_save_succeedsOnSuccessfulFavoriteInsertion() async {
        // Arrange
        let showId = 1
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expectFavorite(sut, for: showId, toCompleteWithError: nil, when: {
            store.completeFavoriteInsertionSuccessfully()
        })
    }
    
    func test_save_failsOnFavoriteInsertionError() async {
        // Arrange
        let showId = 1
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expectFavorite(sut, for: showId, toCompleteWithError: anyNSError(), when: {
            store.completeFavoriteInsertion(with: anyNSError())
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalShowsLoader, store: ShowsStoreSpy) {
        let store = ShowsStoreSpy()
        let sut = LocalShowsLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: LocalShowsLoader, toCompleteWithError expectedError: NSError?, when action: () async -> Void?, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            // Act
            try await sut.save(mockShows().models)
            
            await action()
        } catch {
            // Assert
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
    
    private func expectFavorite(_ sut: LocalShowsLoader, for showId: Int, toCompleteWithError expectedError: NSError?, when action: () async -> Void?, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            // Act
            try await sut.saveFavorite(for: showId)
            
            await action()
        } catch {
            // Assert
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}

