//
//  ShowView.swift
//  TVMaze
//
//  Created by José Briones on 11/5/25.
//

import SwiftUI

struct ShowView: View {
    let show: Show
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top, spacing:16) {
                ImageView(url: show.imageURL)
                Text(show.summary)
                    .font(.footnote)
                    .lineLimit(14)
            }
            VStack(alignment: .leading, spacing: 8) { 
                if !show.genres.isEmpty{
                    Text("Genres: ").bold() + Text(show.genres)
                        .font(.callout)
                }
                if !show.schedule.isEmpty {
                    Text("Schedule: ").bold() + Text(show.schedule)
                        .font(.callout)
                }
            }
        }
        .padding(16)
    }
}

#Preview {
    ShowView(show: MockShowsViewModel.mockShow())
}
