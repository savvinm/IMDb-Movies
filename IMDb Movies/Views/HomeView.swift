//
//  HomeView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var filmsViewModel = FilmsListViewModel()

    var body: some View {
        switch filmsViewModel.status {
        case .loading:
            ProgressView()
        case .success:
            filmsBody
        case .error(let error):
            Text(error.localizedDescription)
        }
    }
    
    private var filmsBody: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    filmsHorizontalLists(in: geometry)
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    private func filmsHorizontalLists(in geometry: GeometryProxy) -> some View {
        VStack {
            PostersHorizontalScroll(title: "In theaters", items: filmsViewModel.inTheaters, geometry: geometry)
            PostersHorizontalScroll(title: "Coming soon", items: filmsViewModel.comingSoon, geometry: geometry)
            PostersHorizontalScroll(title: "Popular now", items: filmsViewModel.mostPopular, geometry: geometry)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
