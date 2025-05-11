//
//  PeopleViewModel.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

final class PeopleViewModel: ObservableObject {
    
    @Published var people = [Person]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil
    @Published var searchText: String = ""
    
    private let peopleLoader: () async throws -> [Person]
    
    init(peopleLoader: @escaping () async throws -> [Person]) {
        self.peopleLoader = peopleLoader
    }
    
    @MainActor
    func loadPeople() async {
        isLoading = true
        do {
            people = try await peopleLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load shows: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

final class MockPeopleViewModel {
    static func mockPerson() -> Person {
        Person(id: 1,
               name: "Mike Vogel",
               imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/0/1815.jpg")!)
    }
    
    static func mockPeopleLoader() async throws -> [Person] {
        return [mockPerson()]
    }
}

