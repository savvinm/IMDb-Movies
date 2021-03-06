//
//  InListPosterView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 13.06.2022.
//

import SwiftUI

struct InListPosterView: View {
    private let film: Film?
    private let filmId: String
    private let title: String
    private let description: String
    private let imageURL: String?
    private let imagePath: String?
    private let imdbRating: String?
    private let localDataViewModel: LocalDataViewModel?
    private let isLocal: Bool
    
    init(poster: Poster) {
        film = nil
        filmId = poster.id
        title = poster.title
        description = poster.description ?? ""
        imageURL = poster.imageURL
        imagePath = nil
        imdbRating = poster.imdbRating
        localDataViewModel = nil
        isLocal = false
    }
    init(film: Film, localDataViewModel: LocalDataViewModel) {
        self.film = film
        filmId = film.id
        title = film.fullTitle
        description = ""
        imageURL = nil
        imagePath = film.imagePath
        imdbRating = film.imdbRating
        self.localDataViewModel = localDataViewModel
        isLocal = true
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationLink(destination: {
                isLocal ? FilmDetailView(film: film!) : FilmDetailView(filmId: filmId)
            }, label: {
                HStack {
                    poster
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height)
                    textBlock
                }
                .contentShape(TapShape())
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var textBlock: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text(title)
                    .font(.headline)
                Text(description)
                Spacer()
            }
            .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
    
    private var poster: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                posterImage(in: geometry)
                if imdbRating != nil && imdbRating != "" {
                    RatingIcon(value: imdbRating!)
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                        .padding(5)
                }
            }
        }
    }
    
    private func posterImage(in geometry: GeometryProxy) -> some View {
        VStack {
            if imageURL != nil {
                ResizableAsyncImage(stringURL: imageURL!)
            }
            else if
                let imagePath = imagePath,
                let image = localDataViewModel?.getImage(in: imagePath)
            {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .clipped()
        .cornerRadius(10)
    }
}
