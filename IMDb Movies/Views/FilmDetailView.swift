//
//  FilmDetailView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 29.05.2022.
//

import SwiftUI

struct FilmDetailView: View {
    @ObservedObject var filmDetailViewModel: FilmDetailViewModel
    
    init(filmId: String) {
        filmDetailViewModel = FilmDetailViewModel(filmId: filmId)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            switch filmDetailViewModel.status {
            case .succes:
                filmBody(for: filmDetailViewModel.film!)
            case .loading:
                ProgressView()
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
        .onAppear { filmDetailViewModel.updateFilm() }
            //.navigationBarHidden(true)
    }
    
    private func filmBody(for film: Film) -> some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    posterAndRating(for: film, in: geometry)
                    titleBlock(for: film)
                    genresBlock(for: film)
                    descriptionBlock(for: film, in: geometry)
                    PostersHorizontalScroll(title: "More like this", items: film.similars, geometry: geometry)
                }
                .padding()
        }
        }
        //.navigationBarTitleDisplayMode(.inline)
        .navigationTitle(film.fullTitle)
    }
    
    private func posterAndRating(for film: Film, in geometry: GeometryProxy) -> some View {
        HStack(alignment: .top) {
            poster(for: film, in: geometry)
            Spacer()
            ratingBlock(for: film)
            Spacer()
        }
    }
    
    private func poster(for film: Film, in geometry: GeometryProxy) -> some View {
        AsyncImage(url: URL(string: film.posterURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.35)
                .cornerRadius(10)
        } placeholder: {
            ProgressView()
        }
        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.35)
    }
    
    private func ratingBlock(for film: Film) -> some View {
        VStack {
            VStack {
                Text("IMDb Rating")
                    .fontWeight(Font.Weight.semibold)
                HStack {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("\(film.imdbRating)/10")
                }
            }
            VStack {
                Text("Your rating")
                    .fontWeight(Font.Weight.semibold)
                HStack {
                    if film.userRating != nil {
                        Image(systemName: "star.fill").foregroundColor(.blue)
                        Text(String(film.userRating!))
                    } else {
                        Image(systemName: "star").foregroundColor(.blue)
                        Button(action: {}, label: { Text("Rate") })
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .font(.headline)
    }
    
    private func titleBlock(for film: Film) -> some View {
        VStack(alignment: .leading) {
            /*Text(film.title)
                .font(.title)*/
            HStack {
                Text(film.year)
                Text(film.contentRating)
                Text(film.runtimeStr)
            }
        }
    }
    private func genresBlock(for film: Film) -> some View {
        HStack {
            Text(film.genres)
                .padding(.bottom)
        }
    }
    private func descriptionBlock(for film: Film, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text(film.plot).padding(.bottom)
            Divider()
            ActorsHorizontalScroll(title: "Top cast", items: film.actors)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
                .padding(.bottom)
            Divider()
            descriptionSection(title: "Directors", value: film.directors)
            Divider()
            descriptionSection(title: "Writers", value: film.writers)
            Divider()
        }
        .padding(.bottom)
    }
    private func descriptionSection(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .font(.headline)
            Text(value)
        }
    }
}
