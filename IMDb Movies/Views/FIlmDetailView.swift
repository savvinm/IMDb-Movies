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
            VStack(alignment: .center) {
                switch filmDetailViewModel.status {
                case .succes:
                    filmBody(for: filmDetailViewModel.film!, in: geometry)
                case .loading:
                    ProgressView()
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .onAppear { filmDetailViewModel.updateFilm() }
            //.navigationBarHidden(true)
        }
    }
    
    private func filmBody(for film: Film, in geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                titleBlock(for: film)
                posterAndRating(for: film, in: geometry)
                genresBlock(for: film)
                descriptionBlock(for: film, in: geometry)
                PostersHorizontalScroll(title: "More like this", items: film.similars, geometry: geometry)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(film.fullTitle)
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
    private func descriptionBlock(for film: Film, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text(film.plot)
            Divider()
            ActorsHorizontalScroll(title: "Top cast", items: film.actors)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
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
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .fontWeight(Font.Weight.semibold)
                horizontalList(in: geometry)
            }
        }
    }
    
    private func horizontalList(in geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(items) { filmActor in
                    infoView(for: filmActor)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                }
            }
        }
    }
    
    private func infoView(for filmActor: Film.Actor) -> some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                image(imageURL: URL(string: filmActor.imageURL))
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height)
                Spacer()
                actorInfo(for: filmActor)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            /*.background {
                Rectangle()
                    .stroke(lineWidth: 3)
                    .foregroundColor(.secondary)
                    .cornerRadius(5)
            }*/
        }
    }
    
    private func image(imageURL: URL?) -> some View {
        GeometryReader { geometry in
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .cornerRadius(5)
            } placeholder: {
                ProgressView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func actorInfo(for filmActor: Film.Actor) -> some View {
        VStack(alignment: .center) {
            Text(filmActor.name)
                .multilineTextAlignment(.center)
            Text("as")
            Text(filmActor.asCharacter)
                .multilineTextAlignment(.center)
        }
    }
}
