//
//  ShowDetailViewModel.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import Foundation

final class ShowDetailViewModel: ObservableObject {
    
    @Published var episodes = [Episode]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil
    
    private let episodesLoader: () async throws -> [Episode]
    
    init(episodesLoader: @escaping () async throws -> [Episode]) {
        self.episodesLoader = episodesLoader
    }
        
    @MainActor
    func loadEpisodes() async {
        isLoading = true
        do {
            episodes = try await episodesLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load episodes: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

final class MockEpisodesViewModel {
    static func mockEpisodesLoader() async throws -> [Episode] {
        //TODO: Add real data
        return [Episode(id: 1,
                        name: "",
                        imageURL: URL(string: "")!,
                        season: 1,
                        number: 1,
                        summary: "")]
    }
}

