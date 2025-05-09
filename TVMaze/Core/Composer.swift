//
//  Composer.swift
//  TVMaze
//
//  Created by José Briones on 8/5/25.
//

import Foundation
import SwiftUI

class Composer {
    private let baseURL: URL
    private let httpClient: URLSessionHTTPClient

    init(baseURL: URL, httpClient: URLSessionHTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
    }
    
    static func makeComposer() -> Composer {
        
        let baseURL = URL(string: "https://api.tvmaze.com/")!
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
                
        return Composer(baseURL: baseURL,httpClient: httpClient)
    }
    

    func composeShowsViewModel() -> ShowsViewModel {
        let showsLoader: () async throws -> [Show] = { [baseURL, httpClient] in
            
            let url = ShowsEndpoint.getShows(page: 0).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            let shows = try ShowsMapper.map(data, from: response)

            return shows
        }
        
        return ShowsViewModel(showsLoader: showsLoader)
    }
    
    func composeShowDetailViewModel(for show: Show) -> ShowDetailViewModel {
        let episodesLoader: () async throws -> [Episode] = { [baseURL, httpClient] in
            
            let url = EpisodesEndpoint.getEpisodes(showId: show.id).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            let episodes = try EpisodesMapper.map(data, from: response)

            return episodes
        }
        
        return ShowDetailViewModel(episodesLoader: episodesLoader)
    }
    
    func composePeopleViewModel() -> PeopleViewModel {
        let peopleLoader: () async throws -> [Person] = { [baseURL, httpClient] in
            
            let url = PeopleEndpoint.getPeople(page: 0).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            let people = try PeopleMapper.map(data, from: response)

            return people
        }
        
        return PeopleViewModel(peopleLoader: peopleLoader)
    }
    
    func composePersonDetailViewModel(for person: Person) -> PersonDetailViewModel {
        let personShowsLoader: () async throws -> [PersonShow] = { [baseURL, httpClient] in
            
            let url = PersonShowsEndpoint.getPersonShows(personId: person.id).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            let personShows = try PersonShowsMapper.map(data, from: response)

            return personShows
        }
        
        return PersonDetailViewModel(personShowsLoader: personShowsLoader)
    }
}
