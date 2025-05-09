//
//  ShowsView.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import SwiftUI

struct ShowsView: View {
    @ObservedObject var showsViewModel: ShowsViewModel
    @Binding var navigationPath: NavigationPath
    
    @State private var searchText = ""
    
    var shows: [Show] {
        if searchText.isEmpty {
            return showsViewModel.shows
        } else {
            return showsViewModel.shows.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            if showsViewModel.isLoading {
                ProgressView("Loading shows...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(shows) { show in
                            Button {
                                navigationPath.append(show)
                            } label: {
                                ShowCardView(show: show)
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
            await showsViewModel.loadShows()
        }
        .navigationTitle("Shows")
        .alert(item: $showsViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ShowCardView: View {
    let show: Show
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ImageView(url: show.imageURL)
            
            Text(show.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

struct ImageView: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                // Loading placeholder
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    )
            case .success(let image):
                // Successful image load
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                // Error placeholder
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(6)
    }
}

#Preview {
    let showsViewModel = ShowsViewModel(showsLoader: MockShowsViewModel.mockShowsLoader)
    
    ShowsView(showsViewModel: showsViewModel,
              navigationPath: .constant(NavigationPath()))
}
