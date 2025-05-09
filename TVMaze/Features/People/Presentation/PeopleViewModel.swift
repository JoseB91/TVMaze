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

//final class MockShowsViewModel {
//    static func mockShowsLoader() async throws -> [Show] {
//        return [Show(id: 250,
//                     name: "Kirby Buckets",
//                     imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/1/4600.jpg")!,
//                     schedule: "Schedule: Monday, Tuesday, Wednesday, Thursday, Friday at 07:00",
//                     genres: "Comedy",
//                     summary: "The single-camera series that mixes live-action and animation stars Jacob Bertrand as the title character. Kirby Buckets introduces viewers to the vivid imagination of charismatic 13-year-old Kirby Buckets, who dreams of becoming a famous animator like his idol, Mac MacCallister. With his two best friends, Fish and Eli, by his side, Kirby navigates his eccentric town of Forest Hills where the trio usually find themselves trying to get out of a predicament before Kirby's sister, Dawn, and her best friend, Belinda, catch them. Along the way, Kirby is joined by his animated characters, each with their own vibrant personality that only he and viewers can see.")]
//    }
//}

