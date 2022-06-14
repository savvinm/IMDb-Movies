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
        case .succes:
            filmsBody
        case .error(let error):
            Text(error.localizedDescription)
        }
    }
    
    private var filmsBody: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    filmsHorizontalLists(in: geometry)
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    private func filmsHorizontalLists(in geometry: GeometryProxy) -> some View {
        VStack {
            PostersHorizontalScroll(title: "In theaters", items: filmsViewModel.inTheaters)
                .frame(width: geometry.size.width, height: geometry.size.width * 0.75)
            PostersHorizontalScroll(title: "Coming soon", items: filmsViewModel.comingSoon)
                .frame(width: geometry.size.width, height: geometry.size.width * 0.75)
            PostersHorizontalScroll(title: "Popular now", items: filmsViewModel.mostPopular)
                .frame(width: geometry.size.width, height: geometry.size.width * 0.75)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
