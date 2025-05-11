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
        VStack {
            ShowView(show: personShowViewModel.show)
        }
        Spacer()
        .navigationTitle(personShowViewModel.show.name)
        .task {
            await personShowViewModel.loadPersonShow()
        }
    }
}

#Preview {
    let personShowViewModel = PersonShowViewModel(personShowLoader: MockPersonShowViewModel.mockPersonShowLoader)
    
    PersonShowView(personShowViewModel: personShowViewModel)
}
