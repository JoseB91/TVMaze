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
            // Use a ViewModifier or a GenericView
            VStack(alignment: .leading, spacing: 16) {
                ImageView(url: episode.imageURL)
                VStack(alignment: .leading, spacing: 4) {
                    Text(episode.summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 8) {
                    //                        Text("Episode Info")
                    //                            .font(.title3)
                    //                            .bold()
                    Text("Season \(episode.season), Episode \(episode.number)")
                    //                        Text("Airdate: Sunday May 11, 2025 at 21:00")
                    //                        Text("Runtime: 60 minutes")
                    //                        Divider()
                    //                        Text("Writer: Craig Mazin")
                    //                        Text("Director: Stephen Williams")
                }
                .padding(.horizontal)
            }
        }
        .padding(16)
        .navigationTitle(episode.name)
    }
}


//struct EpisodeDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EpisodeDetailView(episode: Episode())
//    }
//}
