//
//  EpisodesView.swift
//  TVMaze
//
//  Created by José Briones on 13/5/25.
//

import SwiftUI

struct EpisodesView: View {
    @State private var selectedSeason = 1
    let episodes: [Episode]
    let seasons: Int
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading) {
            // Show header content
            Text("Episodes:")
                .font(.callout)
                .bold()

            Picker("Season", selection: $selectedSeason) {
                ForEach(1..<seasons, id: \.self) { season in
                    Text("S\(season)")//.tag(season)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Episodes list
            List {
                ForEach(episodesForSeason(selectedSeason), id: \.id) { episode in
                    EpisodeRow(episode: episode, navigationPath: $navigationPath)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    func episodesForSeason(_ seasonNumber: Int) -> [Episode] {
        episodes.filter { $0.season == seasonNumber }
    }
}

struct EpisodeRow: View {
    let episode: Episode
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("E\(episode.number)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(width: 40, alignment: .leading)
                
                Button {
                    navigationPath.append(episode)
                } label: {
                    Text(episode.name)
                }
                .buttonStyle(PlainButtonStyle())
                .listRowSeparator(.hidden)

                //Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

