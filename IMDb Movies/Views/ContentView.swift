//
//  ContentView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var filmsViewModel = FilmsViewModel()
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    filmsHorizontalLists(in: geometry)
                }
                .navigationBarHidden(true)
                //.onAppear { filmsViewModel.fetchFilms() }
            }
        }
    }
    
    private func filmsHorizontalLists(in geometry: GeometryProxy) -> some View {
        VStack {
            FilmsHorizontalScroll(title: "In theaters", items: filmsViewModel.inTheaters, geometry: geometry, filmsViewModel: filmsViewModel)
            FilmsHorizontalScroll(title: "Coming soon", items: filmsViewModel.comingSoon, geometry: geometry, filmsViewModel: filmsViewModel)
            FilmsHorizontalScroll(title: "Top 250", items: filmsViewModel.top250, geometry: geometry, filmsViewModel: filmsViewModel)
        }
        .padding()
    }
}

struct FilmsHorizontalScroll: View {
    let title: String
    let items: [Film]
    let geometry: GeometryProxy
    let filmsViewModel: FilmsViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(Font.Weight.semibold)
            horizontalList(in: geometry)
        }
    }
    
    private func horizontalList(in geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(items) { film in
                    filmNavigationLink(for: film)
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.35)
                }
            }
        }
    }
    
    private func filmNavigationLink(for film: Film) -> some View {
        GeometryReader { geometry in
            NavigationLink(destination: { FilmDetailView(film: film, filmsViewModel: filmsViewModel) }, label: {
                filmPreviev(for: film, in: geometry)
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func filmPreviev(for film: Film, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: film.poster)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
                    .clipped()
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
            Text(film.title)
                .font(.headline)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
