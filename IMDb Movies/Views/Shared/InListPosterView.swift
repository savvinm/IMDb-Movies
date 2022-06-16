//
//  InListPosterView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 13.06.2022.
//

import SwiftUI

struct InListPosterView: View {
    private let filmId: String
    private let title: String
    private let description: String
    private let imageURL: String?
    private let imagePath: String?
    private let imdbRating: String?
    private let savedFilmsViewModel: SavedFilmsViewModel?
    
    init(poster: Poster) {
        filmId = poster.id
        title = poster.title
        description = poster.description ?? ""
        imageURL = poster.imageURL
        imagePath = nil
        imdbRating = poster.imdbRating
        savedFilmsViewModel = nil
    }
    init(film: Film, savedFilmsViewModel: SavedFilmsViewModel) {
        filmId = film.id
        title = film.fullTitle
        description = ""
        imageURL = nil
        imagePath = film.imagePath
        imdbRating = film.imdbRating
        self.savedFilmsViewModel = savedFilmsViewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationLink(destination: FilmDetailView(filmId: filmId), label: {
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
                asyncImage(in: geometry)
            }
            if
                imagePath != nil,
                let image = savedFilmsViewModel?.getImage(in: imagePath!)
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
    
    private func asyncImage(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: URL(string: imageURL!)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
    }
}
