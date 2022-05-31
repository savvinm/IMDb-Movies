//
//  ContentView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 28.05.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var filmsViewModel = FilmsListViewModel()
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    VStack {
                        FilmsHorizontalScroll(title: "In theaters", items: filmsViewModel.inTheaters, geometry: geometry)
                        FilmsHorizontalScroll(title: "Coming soon", items: filmsViewModel.comingSoon, geometry: geometry)
                    }
                    .padding()
                }
                .navigationBarHidden(true)
                //.onAppear { filmsViewModel.fetchFilms() }
            }
        }
    }
}

struct FilmsHorizontalScroll: View {
    let title: String
    let items: [Film]
    let geometry: GeometryProxy
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.title).fontWeight(Font.Weight.semibold)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(items) { film in
                        filmPreviev(for: film)
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.35)
                    }
                }
            }
        }
    }
    
    func filmPreviev(for film: Film) -> some View {
        GeometryReader { geometry in
            NavigationLink(destination: { FIlmDetailView(film: film) }) {
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
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
