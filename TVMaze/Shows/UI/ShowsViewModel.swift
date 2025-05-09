//
//  ShowsViewModel.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import Foundation

final class ShowsViewModel: ObservableObject {
    
    @Published var shows = [Show]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil
    @Published var searchText: String = ""

    
    private let showsLoader: () async throws -> [Show]
    
    init(showsLoader: @escaping () async throws -> [Show]) {
        self.showsLoader = showsLoader
    }
    
    var filteredShows: [Show] {
        if searchText.isEmpty {
            return shows
        } else {
            return shows.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @MainActor
    func loadShows() async {
        isLoading = true
        do {
            shows = try await showsLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load shows: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}

final class MockShowsViewModel {
    static func mockShowsLoader() async throws -> [Show] {
        return [Show(id: 250,
                     name: "Kirby Buckets",
                     imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/1/4600.jpg")!,
                     schedule: "Schedule: Monday at 10:00 PM",
                     genres: "Comedy, Drama",
                     summary: "The single-camera series that mixes live-action and animation stars Jacob Bertrand as the title character. <b>Kirby Bucke…, Kirby is joined by his animated characters, each with their own vibrant personality that only he and viewers can see.")]
    }
}

