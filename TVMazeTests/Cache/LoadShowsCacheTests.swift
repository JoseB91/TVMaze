//
//  LoadShowsCacheTests.swift
//  TVMazeTests
//
//  Created by José Briones on 13/5/25.
//

import XCTest
import TVMaze

final class LoadShowsCacheTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        // Arrange
        let (_, store) = makeSUT()
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act
        _ = try? await sut.load()
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
        
    func test_load_deliversCachedShowsOnNonExpiredCache() async {
        // Arrange
        let shows = mockShows()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWith: .success(shows.models), when: {
            store.completeRetrieval(with: shows.local, timestamp: nonExpiredTimestamp)
        })
    }
        
    func test_load_failsOnExpiredCache() async {
        // Arrange
        let shows = mockShows()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            store.completeRetrievalWithExpiredCache(with: shows.local, timestamp: expiredTimestamp, error: retrievalError)
        })
    }
        
    func test_load_failsOnRetrievalError() async {
        // Arrange
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
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
    
    private func expect(_ sut: LocalShowsLoader, toCompleteWith expectedResult: Result<[Show], Error>, when action: () async -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        await action()

        let receivedResult: Result<[Show], Error>
        
        do {
            let receivedShows = try await sut.load()
            receivedResult = .success(receivedShows)
        } catch {
            receivedResult = .failure(error)
        }

        switch (receivedResult, expectedResult) {
        case let (.success(receivedShows), .success(expectedShows)):
            XCTAssertEqual(receivedShows, expectedShows, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}

