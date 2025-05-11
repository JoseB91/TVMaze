//
//  PersonShowViewModel.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import Foundation

final class PersonShowViewModel: ObservableObject {
    
    @Published var show = Show(id: 0,
                               name: "",
                               imageURL: URL(string: "https://example.com/placeholder.jpg")!,
                               schedule: "",
                               genres: "",
                               summary: "",
                               rating: "",
                               isFavorite: false)
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil
    
    private let personShowLoader: () async throws -> Show
    
    init(personShowLoader: @escaping () async throws -> Show) {
        self.personShowLoader = personShowLoader
    }
        
    @MainActor
    func loadPersonShow() async {
        isLoading = true
        do {
            show = try await personShowLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load person show: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

final class MockPersonShowViewModel {
    static func mockPersonShowLoader() async throws -> Show {
        return MockShowsViewModel.mockShow()
    }
}

