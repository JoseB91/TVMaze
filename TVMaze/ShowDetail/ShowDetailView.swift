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
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing:16) {
                ImageView(url: show.imageURL)
                
                Text(show.summary)
                    .font(.footnote)
                    .lineLimit(12)
            }
            Text(show.genres)
                .font(.body)
            Divider()
            Text(show.schedule)
                .font(.body)
        }
        VStack{
            ZStack {
                if showDetailViewModel.isLoading {
                    ProgressView("Loading episodes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    let last = showDetailViewModel.episodes.last
                    if let lastSeason = last?.season {
                        List {
                            ForEach(1...lastSeason, id: \.self) { seasonNumber in
                                Section(header: Text("Season \(seasonNumber)")) {
                                    ForEach(showDetailViewModel.episodes.filter { $0.season == seasonNumber }) { episode in
                                        Text(episode.name)
                                            .font(.body)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(show.name)
        .task {
            await showDetailViewModel.loadEpisodes()
        }
        .padding(16)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    $show.isFavorite.wrappedValue?.toggle()
//                }) {
//                    $show.isFavorite.wrappedValue ?? false ? Image(systemName: Constants.starFillImage).foregroundColor(.yellow): Image(systemName: Constants.starImage).foregroundColor(.gray)
//                }
//            }
//        }
    }
}
