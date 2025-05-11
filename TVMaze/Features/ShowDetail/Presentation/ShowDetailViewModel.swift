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

final class MockShowDetailViewModel {
    static func mockEpisode() -> Episode {
        return Episode(id: 20849,
                       name: "Cars, Buses and Lawnmowers",
                       imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_landscape/303/759608.jpg")!,
                       season: 1,
                       number: 1,
                       summary: "Kirby learns about a character design contest featuring the ultimate prize - a chance to meet idol Mac McCallister and debut an animated character on TV. He plans to attend with Fish and Eli, but when they unexpectedly get stranded at school hours before the contest, they devise a plan that accidently places them in the middle of \"Clown Town,\" an abandoned area of the city where creepy clowns reign. Meanwhile, Dawn realizes Kirby is using an embarrassing drawing of her titled \"Dawnzilla\" as his submission for the contest, so she and Belinda do everything in their power to stop him.")
    }
    
    static func mockEpisode2() -> Episode {
        return Episode(id: 20845,
                       name: "Cars",
                       imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_landscape/303/759608.jpg")!,
                       season: 1,
                       number: 1,
                       summary: "Kirby learns about a character design contest featuring the ultimate prize - a chance to meet idol Mac McCallister and debut an animated character on TV. He plans to attend with Fish and Eli, but when they unexpectedly get stranded at school hours before the contest, they devise a plan that accidently places them in the middle of \"Clown Town,\" an abandoned area of the city where creepy clowns reign. Meanwhile, Dawn realizes Kirby is using an embarrassing drawing of her titled \"Dawnzilla\" as his submission for the contest, so she and Belinda do everything in their power to stop him.")
    }
    
    static func mockEpisodesLoader() async throws -> [Episode] {
        return [mockEpisode(), mockEpisode2()]
    }
}

