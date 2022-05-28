//
//  ContentView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import SwiftUI

struct ContentView: View {
    let filmsViewModel = FilmsListViewModel()
    var body: some View {
        Text("Hello, world!")
            .padding()
        Button(action: {
            filmsViewModel.fetchFilms()
        }, label: { Text("Fetch films") })
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
