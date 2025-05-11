//
//  TVMazeApp.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import SwiftUI

@main
struct TVMazeApp: App {
    private let composer: Composer
    
    init() {
        self.composer = Composer.makeComposer()
    }
    
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showsNavigationPath = NavigationPath()
    @State private var peopleNavigationPath = NavigationPath()
    @State private var favoritesNavigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                // Shows Tab
                NavigationStack(path: $showsNavigationPath) {
                    ShowsView(showsViewModel: composer.composeShowsViewModel(),
                              navigationPath: $showsNavigationPath,
                              isFavoriteView: false)
                    .navigationDestination(for: Show.self) { show in
                        ShowDetailView(showDetailViewModel: composer.composeShowDetailViewModel(for: show),
                                       navigationPath: $showsNavigationPath,
                                       show: show)
                        .navigationDestination(for: Episode.self) { episode in
                            EpisodeDetailView(episode: episode)
                        }
                    }
                }
                .tabItem {
                    Label("Shows", systemImage: "tv")
                }
                .tag(0)
                
                // People Tab
                NavigationStack(path: $peopleNavigationPath) {
                    PeopleView(peopleViewModel: composer.composePeopleViewModel(),
                               navigationPath: $peopleNavigationPath)
                    .navigationDestination(for: Person.self) { person in
                        PersonDetailView(personDetailViewModel: composer.composePersonDetailViewModel(for: person), navigationPath: $peopleNavigationPath,
                                         person: person)
                    }
                    .navigationDestination(for: URL.self) { url in
                        PersonShowView(personShowViewModel: composer.composePersonShowViewModel(with: url))
                    }
                }
                .tabItem {
                    Label("People", systemImage: "person.fill")
                }
                .tag(1)
                
                // Favorites Tab
                NavigationStack(path: $favoritesNavigationPath) {
                    ShowsView(showsViewModel: composer.composeShowsViewModel(),
                              navigationPath: $favoritesNavigationPath,
                              isFavoriteView: true)
                    .navigationDestination(for: Show.self) { show in
                        ShowDetailView(showDetailViewModel: composer.composeShowDetailViewModel(for: show),
                                       navigationPath: $favoritesNavigationPath,
                                       show: show)
                        .navigationDestination(for: Episode.self) { episode in
                            EpisodeDetailView(episode: episode)
                        }
                    }
                }
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(2)
                
            }
        }
    }
}
