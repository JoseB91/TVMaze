//
//  PersonDetailView.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import SwiftUI

struct PersonDetailView: View {
    
    @ObservedObject var personDetailViewModel: PersonDetailViewModel
    @Binding var navigationPath: NavigationPath
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let imageURL = person.imageURL {
                ImageView(url: imageURL)
            } else {
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
                    .cornerRadius(6)
            }
            ZStack {
                if personDetailViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    List {
                        Section(header: Text("Shows")) {
                            ForEach(personDetailViewModel.personShows) { personShow in
                                Text(personShow.name)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .navigationTitle(person.name)
        .task {
            await personDetailViewModel.loadPersonShows()
        }
        .padding(16)
    }
}
