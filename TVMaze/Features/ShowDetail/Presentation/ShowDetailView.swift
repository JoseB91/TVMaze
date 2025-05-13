//
//  ShowDetailView.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import SwiftUI

struct ShowDetailView: View {
    
    @ObservedObject var showDetailViewModel: ShowDetailViewModel
    @Binding var navigationPath: NavigationPath
    let show: Show
    
    var body: some View {
        ShowView(show: show)
        VStack{
            ZStack {
                if showDetailViewModel.isLoading {
                    ProgressView("Loading episodes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    let last = showDetailViewModel.episodes.last
                    if let lastSeason = last?.season {
                        EpisodesView(episodes: showDetailViewModel.episodes,
                                     seasons: lastSeason,
                                     navigationPath: $navigationPath)
                    }
                }
            }
        }
        .navigationTitle(show.name)
        .task {
            await showDetailViewModel.loadEpisodes()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    let showDetailViewModel = ShowDetailViewModel(episodesLoader: MockShowDetailViewModel.mockEpisodesLoader)
    
    ShowDetailView(showDetailViewModel: showDetailViewModel,
                   navigationPath: .constant(NavigationPath()),
                   show: MockShowsViewModel.mockShow())
}
