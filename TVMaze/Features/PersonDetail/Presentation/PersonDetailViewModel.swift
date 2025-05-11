//
//  PersonDetailViewModel.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

final class PersonDetailViewModel: ObservableObject {
    
    @Published var personShows = [PersonShow]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil
    
    private let personShowsLoader: () async throws -> [PersonShow]
    
    init(personShowsLoader: @escaping () async throws -> [PersonShow]) {
        self.personShowsLoader = personShowsLoader
    }
    
    @MainActor
    func loadPersonShows() async {
        isLoading = true
        do {
            personShows = try await personShowsLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load personShows: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

final class MockPersonDetailViewModel {
    static func mockPersonShow() -> PersonShow {
        return PersonShow(name: "Under the Dome", showURL: URL(string: "https://api.tvmaze.com/shows/1")!)
    }
    
    static func mockPersonShowsLoader() async throws -> [PersonShow] {
        return [mockPersonShow()]
    }
}
