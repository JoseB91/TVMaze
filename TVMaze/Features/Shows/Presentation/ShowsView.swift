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

struct ShowCardView: View {
    let show: Show
    @ObservedObject var showsViewModel: ShowsViewModel
    let isFavoriteView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ImageView(url: show.imageURL)
            
            Text(show.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
            
            HStack(spacing: 12) {
                if show.rating != "" {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.secondary)
                        Text(show.rating)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                if !isFavoriteView {
                    Button(action: {
                        showsViewModel.toggleFavorite(for: show)
                    }) {
                        Image(systemName: show.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(show.isFavorite ? .red : .secondary)
                    }
                }
            }
        }
        .cornerRadius(8)
    }
}

struct ImageView: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    )
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            case .failure:
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
                
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(6)
        .shadow(radius: 2)
    }
}

#Preview {
    let showsViewModel = ShowsViewModel(showsLoader: MockShowsViewModel.mockShowsLoader,
                                        localShowsLoader: MockShowsViewModel.mockLocalShowsLoader())
    
    ShowsView(showsViewModel: showsViewModel,
              navigationPath: .constant(NavigationPath()),
              isFavoriteView: false)
}
