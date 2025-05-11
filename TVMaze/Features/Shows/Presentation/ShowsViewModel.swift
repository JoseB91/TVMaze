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
    private let localShowsLoader: LocalShowsLoader
    
    init(showsLoader: @escaping () async throws -> [Show], localShowsLoader: LocalShowsLoader) {
        self.showsLoader = showsLoader
        self.localShowsLoader = localShowsLoader
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
    
    func toggleFavorite(for show: Show) {
        // First toggle the UI state immediately for better user feedback
        if let index = shows.firstIndex(where: { $0.id == show.id }) {
            shows[index].isFavorite.toggle()
            
            Task {
                do {
                    try await localShowsLoader.saveFavorite(for: show.id)
                    
                    // Optionally refresh data after saving if needed
                    // await loadShows()
                } catch {
                    // Handle the error
                    DispatchQueue.main.async {
                        self.errorMessage = ErrorModel(message: "Failed to save favorite: \(error.localizedDescription)")
                        
                        // Revert the UI change since the save failed
                        if let index = self.shows.firstIndex(where: { $0.id == show.id }) {
                            self.shows[index].isFavorite.toggle()
                        }
                    }
                }
            }
        }
    }
}



final class MockShowsViewModel {
    static func mockShow() -> Show {
        return Show(id: 250,
                    name: "Kirby Buckets",
                    imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/1/4600.jpg")!,
                    schedule: "Weekdays at 07:00",
                    genres: "Comedy",
                    summary: "The single-camera series that mixes live-action and animation stars Jacob Bertrand as the title character. Kirby Buckets introduces viewers to the vivid imagination of charismatic 13-year-old Kirby Buckets, who dreams of becoming a famous animator like his idol, Mac MacCallister. With his two best friends, Fish and Eli, by his side, Kirby navigates his eccentric town of Forest Hills where the trio usually find themselves trying to get out of a predicament before Kirby's sister, Dawn, and her best friend, Belinda, catch them. Along the way, Kirby is joined by his animated characters, each with their own vibrant personality that only he and viewers can see.",
                    rating: "",
                    isFavorite: false)
    }
    
    static func mockShowsLoader() async throws -> [Show] {
        return [mockShow()]
    }
    
    static func mockLocalShowsLoader() -> LocalShowsLoader {
        return LocalShowsLoader(store: MockShowStore(), currentDate: Date.init)
    }
}

final class MockShowStore: ShowsStore {
    func deleteCache() async throws {
    }
    
    func insert(_ shows: [LocalShow], timestamp: Date) async throws {
    }
    
    func retrieve() async throws -> CachedShows? {
        return nil
    }
    
    func insertFavorite(for showId: Int) async throws {
    }
}

