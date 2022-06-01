//
//  FIlmDetailView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 29.05.2022.
//

import SwiftUI

struct FilmDetailView: View {
    let film: Film
    let filmsViewModel: FilmsViewModel
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    titleBlock
                    AsyncImage(url: URL(string: film.poster)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.3)
                    } placeholder: {
                        ProgressView()
                    }
                    genresBlock
                    descriptionBlock
                    ratingBlock
                }
                .padding()
            }
            //.navigationBarHidden(true)
        }
    }
    
    private var ratingBlock: some View {
        VStack {
            Text("Your rating").font(.headline)
            Text(String(filmsViewModel.getRating(for: film) ?? 0))
        }
        .onTapGesture {
            filmsViewModel.rate(film, rating: 6)
        }
    }
    
    private var titleBlock: some View {
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
    private var genresBlock: some View {
        HStack {
            ForEach(film.genres, id: \.self) { genre in
                Text(genre)
                    .padding(5)
                    .background {
                        Capsule().stroke(Color.secondary, lineWidth: 3)
                    }
            }
            .padding(.vertical)
        }
    }
    private var descriptionBlock: some View {
        VStack(alignment: .leading) {
            Text(film.plot)
            Divider()
            descriptionSection(title: "Directors", value: film.directors)
            Divider()
            descriptionSection(title: "Stars", value: film.stars)
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

struct HorizontalPersonsScroll: View {
    let title: String
    var body: some View {
        LazyHStack {
            
        }
    }
}
