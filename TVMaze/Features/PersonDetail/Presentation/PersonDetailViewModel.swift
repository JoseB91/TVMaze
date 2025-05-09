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

//final class MockEpisodesViewModel {
//    static func mockEpisodesLoader() async throws -> [Episode] {
//        //TODO: Add real data
//        return [Episode(id: 1,
//                        name: "",
//                        imageURL: URL(string: "")!,
//                        season: 1,
//                        number: 1,
//                        summary: "")]
//    }
//}

