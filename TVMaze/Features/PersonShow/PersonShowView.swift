//
//  PersonShowView.swift
//  TVMaze
//
//  Created by José Briones on 9/5/25.
//

import SwiftUI

struct PersonShowView: View {
    
    @ObservedObject var personShowViewModel: PersonShowViewModel
    
    var body: some View {
        ShowView(show: personShowViewModel.show)
        .padding(16)
        .navigationTitle(personShowViewModel.show.name)
        .task {
            await personShowViewModel.loadPersonShow()
        }
    }
}
