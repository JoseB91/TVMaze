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
            }
            Text(show.genres)
                .font(.body)
            Divider()
            Text(show.schedule)
                .font(.body)
        }
        .padding(16)
    }
}
