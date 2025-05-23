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
        VStack(alignment: .center, spacing: 24) {
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
                                Button {
                                    navigationPath.append(personShow.showURL)
                                } label: {
                                    Text(personShow.name)
                                }
                                .buttonStyle(PlainButtonStyle())
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
    }
}

#Preview {
    let personDetailViewModel = PersonDetailViewModel(personShowsLoader: MockPersonDetailViewModel.mockPersonShowsLoader)
    
    PersonDetailView(personDetailViewModel: personDetailViewModel,
                   navigationPath: .constant(NavigationPath()),
                     person: MockPeopleViewModel.mockPerson())
}
