//
//  PeopleView.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import SwiftUI

struct PeopleView: View {
    @ObservedObject var peopleViewModel: PeopleViewModel
    @Binding var navigationPath: NavigationPath
    
    @State private var searchText = ""
    
    var people: [Person] {
        if searchText.isEmpty {
            return peopleViewModel.people
        } else {
            return peopleViewModel.people.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            if peopleViewModel.isLoading {
                ProgressView("Loading people...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(people) { person in
                            Button {
                                navigationPath.append(person)
                            } label: {
                                PersonCardView(person: person)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .searchable(text: $searchText, prompt: "Search shows")
                }
                .background(Color(.systemGray6))
            }
        }
        .task {
            await peopleViewModel.loadPeople()
        }
        .navigationTitle("People")
        .alert(item: $peopleViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct PersonCardView: View {
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading) {
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
            Text(person.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

//#Preview {
//    let showsViewModel = ShowsViewModel(showsLoader: MockShowsViewModel.mockShowsLoader)
//
//    ShowsView(showsViewModel: showsViewModel,
//              navigationPath: .constant(NavigationPath()))
//}
