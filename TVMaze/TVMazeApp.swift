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
    
    @State private var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                ShowsView(showsViewModel: composer.composeShowsViewModel(),
                          navigationPath: $navigationPath)
                .navigationDestination(for: Show.self) { show in
                    ShowDetailView(showDetailViewModel: composer.composeShowDetailViewModel(for: show),
                                   navigationPath: $navigationPath,
                                   show: show)
                }
            }
        }
    }
}
