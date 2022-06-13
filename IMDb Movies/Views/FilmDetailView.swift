//
//  FilmDetailView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 29.05.2022.
//

import SwiftUI

struct FilmDetailView: View {
    @ObservedObject var filmDetailViewModel: FilmDetailViewModel
    @State var showingRatingFrame = false
    
    init(filmId: String) {
        filmDetailViewModel = FilmDetailViewModel(filmId: filmId)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            switch filmDetailViewModel.status {
            case .succes:
                filmView(for: filmDetailViewModel.film!)
            case .loading:
                ProgressView()
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
        .onAppear { filmDetailViewModel.updateFilm() }
    }
    
    private func filmView(for film: Film) -> some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                filmBody(for: film, in: geometry)
            }
            .onTapGesture { showingRatingFrame = false }
            .overlay(alignment: .center, content: {
                if showingRatingFrame {
                    RatingFrame(geometry: geometry, filmDetailViewModel: filmDetailViewModel, showingRatingFrame: $showingRatingFrame, rating: filmDetailViewModel.film?.userRating)
                }
            })
        }
        .padding()
        .navigationTitle(film.fullTitle)
    }
    
    private func filmBody(for film: Film, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            posterAndRating(for: film, in: geometry)
            titleBlock(for: film)
            genresBlock(for: film)
            descriptionBlock(for: film, in: geometry)
            PostersHorizontalScroll(title: "More like this", items: film.similars)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
        }
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
                    Text("\(film.imdbRating)/\(filmDetailViewModel.maximumRating)")
                }
            }
            .padding()
            VStack {
                Text("Your rating")
                    .fontWeight(Font.Weight.semibold)
                HStack {
                    if film.userRating != nil {
                        Image(systemName: "star.fill").foregroundColor(.blue)
                        Text("\(film.userRating!)/\(filmDetailViewModel.maximumRating)")
                    } else {
                        Image(systemName: "star").foregroundColor(.blue)
                        Text("Rate")
                    }
                }
            }
            .onTapGesture {
                showingRatingFrame = true
            }
            .padding()
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
                .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
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
