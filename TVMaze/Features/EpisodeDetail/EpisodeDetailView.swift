//
//  EpisodeDetailView.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import SwiftUI

struct EpisodeDetailView: View {
    
    let episode: Episode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ImageView(url: episode.imageURL)
                VStack(alignment: .leading, spacing: 4) {
                    Text(episode.summary)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .navigationTitle("S\(episode.season).E\(episode.number) · \(episode.name)")
    }
}

#Preview {
    EpisodeDetailView(episode: MockShowDetailViewModel.mockEpisode())
}
