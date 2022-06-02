//
//  FIlmDetailView.swift
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
        GeometryReader { geometry in
            switch filmDetailViewModel.status {
            case .succes:
                filmBody(for: filmDetailViewModel.film!, in: geometry)
            case .loading:
                ProgressView()
            case .error(let error):
                Text(error.localizedDescription)
            }
            //.navigationBarHidden(true)
        }
    }
    
    private func filmBody(for film: Film, in geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                titleBlock(for: film)
                posterAndRating(for: film, in: geometry)
                genresBlock(for: film)
                descriptionBlock(for: film)
                PostersHorizontalScroll(title: "More like this", items: film.similars, geometry: geometry)
            }
            .padding()
        }
    }
    
    private func posterAndRating(for film: Film, in geometry: GeometryProxy) -> some View {
        HStack(alignment: .top) {
            poster(for: film, in: geometry).cornerRadius(10)
            Spacer()
            ratingBlock(for: film)
            Spacer()
        }
    }
    
    private func poster(for film: Film, in geometry: GeometryProxy) -> some View {
        AsyncImage(url: URL(string: film.posterURL)) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.35)
        } placeholder: {
            ProgressView()
        }
    }
    
    private func ratingBlock(for film: Film) -> some View {
        VStack {
            VStack {
                Text("IMDb Rating")
                HStack {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("\(film.imdbRating)/10")
                }
            }
            VStack {
                Text("Your rating").font(.headline)
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
    }
    
    private func titleBlock(for film: Film) -> some View {
        VStack(alignment: .leading) {
            Text(film.title)
                .font(.title)
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
                .padding(.vertical)
        }
    }
    private func descriptionBlock(for film: Film) -> some View {
        VStack(alignment: .leading) {
            Text(film.plot)
            Divider()
            descriptionSection(title: "Directors", value: film.directors)
            Divider()
            descriptionSection(title: "Writers", value: film.writers)
            Divider()
        }
    }
    private func descriptionSection(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .font(.headline)
            Text(value)
        }
    }
}

struct ActorsHorizontalScroll: View {
    let title: String
    let items: [Film.Actor]
    var body: some View {
        GeometryReader { geometry in
            LazyHStack {
                ForEach(items) { filmActor in
                    infoView(for: filmActor, in: geometry)
                }
            }
        }
    }
    
    private func infoView(for filmActor: Film.Actor, in geometry: GeometryProxy) -> some View {
        HStack(alignment: .top) {
            image(imageURL: URL(string: filmActor.imageURL))
                .frame(width: geometry.size.width * 0.4, height: geometry.size.height)
            actorInfo(for: filmActor)
        }
    }
    
    private func image(imageURL: URL?) -> some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        } placeholder: {
            ProgressView()
        }
    }
    
    private func actorInfo(for filmActor: Film.Actor) -> some View {
        VStack {
            Text(filmActor.name)
            Text("as")
            Text(filmActor.asCharacter)
        }
    }
}
