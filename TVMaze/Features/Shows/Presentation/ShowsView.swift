//
//  ShowsView.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import SwiftUI

struct ShowsView: View {
    @ObservedObject var showsViewModel: ShowsViewModel
    @Binding var navigationPath: NavigationPath
    let isFavoriteView: Bool

    @State private var searchText = ""
    
    var shows: [Show] {
        if searchText.isEmpty {
            let favoriteShows = showsViewModel.shows.filter(\.self.isFavorite)
            return isFavoriteView ? favoriteShows : showsViewModel.shows
        } else {
            let filteredShows = showsViewModel.shows.filter { $0.name.contains(searchText) }
            let favoriteFilteredShows = filteredShows.filter(\.self.isFavorite)
            return isFavoriteView ? favoriteFilteredShows : filteredShows
        }
    }
    
    var body: some View {
        ZStack {
            if isFavoriteView && showsViewModel.shows.filter(\.self.isFavorite).isEmpty {
                Text("Your favorite shows will appear here")
            } else if showsViewModel.isLoading {
                ProgressView("Loading shows...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(shows) { show in
                            Button {
                                navigationPath.append(show)
                            } label: {
                                ShowCardView(show: show,
                                             showsViewModel: showsViewModel,
                                             isFavoriteView: isFavoriteView)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .searchable(text: $searchText, prompt: "Search shows")
                }
                .background(Color(.systemGray6))
            }
        }
        .task {
            await showsViewModel.loadShows()
        }
        .navigationTitle(isFavoriteView ? "Favorites" : "Shows")
        .alert(item: $showsViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    let showsViewModel = ShowsViewModel(showsLoader: MockShowsViewModel.mockShowsLoader,
                                        localShowsLoader: MockShowsViewModel.mockLocalShowsLoader())
    
    ShowsView(showsViewModel: showsViewModel,
              navigationPath: .constant(NavigationPath()),
              isFavoriteView: false)
}
