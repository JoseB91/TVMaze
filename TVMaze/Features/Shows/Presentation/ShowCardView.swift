//
//  ShowCardView.swift
//  TVMaze
//
//  Created by José Briones on 11/5/25.
//

import SwiftUI

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

