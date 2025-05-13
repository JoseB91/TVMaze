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
    @Published var hasMoreContent = true
    @Published var currentPage = 0
    
    private let showsLoader: (_ page: Int, _ append: Bool) async throws -> [Show]
    private let localShowsLoader: LocalShowsLoader
    private let isFavoriteViewModel: Bool
    
    init(showsLoader: @escaping (_ page: Int, _ append: Bool) async throws -> [Show], localShowsLoader: LocalShowsLoader, isFavoriteViewModel: Bool) {
        self.showsLoader = showsLoader
        self.localShowsLoader = localShowsLoader
        self.isFavoriteViewModel = isFavoriteViewModel
    }
    
    @MainActor
    func loadShows() async {
        if isFavoriteViewModel {
            isLoading = true
            do {
                shows = try await showsLoader(0, false)
            } catch {
                errorMessage = ErrorModel(message: "Failed to load favorite shows: \(error.localizedDescription)")
            }
            isLoading = false
        } else {
            if isLoading || !hasMoreContent { return }
            
            isLoading = true
            do {
                let append = currentPage > 0
                shows = try await showsLoader(currentPage, append)
                
                if shows.isEmpty || shows.count < 200 {
                    hasMoreContent = false
                }
                
                currentPage += 1
            } catch {
                errorMessage = ErrorModel(message: "Failed to load shows: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    
    @MainActor
    func refreshShows() async {
        currentPage = 0
        hasMoreContent = true
        shows = []
        
        await loadShows()
    }
        
    func toggleFavorite(for show: Show) {
        if let index = shows.firstIndex(where: { $0.id == show.id }) {
            shows[index].isFavorite.toggle()
            
            Task {
                do {
                    try await localShowsLoader.saveFavorite(for: show.id)
                } catch {
                    await MainActor.run {
                        self.errorMessage = ErrorModel(message: "Failed to save favorite: \(error.localizedDescription)")
                        
                        
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
    
    static func mockShowsLoader(_ page: Int, _ append: Bool) async throws -> [Show] {
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
