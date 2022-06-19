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
    private let isLocal: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    init(filmId: String) {
        filmDetailViewModel = FilmDetailViewModel(filmId: filmId)
        isLocal = false
    }
    
    init(film: Film) {
        filmDetailViewModel = FilmDetailViewModel(film: film)
        isLocal = true
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
            .overlay(alignment: .center) {
                if showingRatingFrame {
                    RatingSetFrame(geometry: geometry, filmDetailViewModel: filmDetailViewModel, showingRatingFrame: $showingRatingFrame, rating: filmDetailViewModel.film?.userRating)
                }
            }
        }
        .padding()
        .navigationTitle(film.fullTitle)
        .toolbar { saveButton }
    }
    
    private var saveButton: some View {
        Button(action: {
            filmDetailViewModel.toggleSaveFilm(presentationMode: isLocal ? presentationMode : nil)
            
        }, label: {
            Image(systemName: filmDetailViewModel.isSaved ? "bookmark.fill" : "bookmark")
        })
    }
    
    private func filmBody(for film: Film, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            posterAndRating(for: film, in: geometry)
            infoBlock(for: film)
            descriptionBlock(for: film, in: geometry)
            if !isLocal && !film.similars.isEmpty {
                PostersHorizontalScroll(title: "More like this", items: film.similars)
                    .frame(width: geometry.size.width, height: geometry.size.width * 0.75)
            }
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
        VStack {
            if film.posterURL != nil {
                ResizableAsyncImage(stringURL: film.posterURL!)
            }
            if
                let imagePath = film.imagePath,
                let image = filmDetailViewModel.getImage(in: imagePath)
            {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: geometry.size.width * 0.45, height: geometry.size.width * 0.65)
        .clipped()
        .cornerRadius(10)
    }
    
    private func ratingBlock(for film: Film) -> some View {
        VStack {
            if film.imdbRating != nil {
                VStack {
                    Text("IMDb Rating")
                        .fontWeight(Font.Weight.semibold)
                    HStack {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        Text("\(film.imdbRating!)/\(filmDetailViewModel.maximumRating)")
                    }
                }
                .padding()
            }
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
    
    private func infoBlock(for film: Film) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(film.year)
                Text(film.contentRating ?? "")
                Text(film.runtimeStr ?? "")
            }
            Text(film.genres)
                .padding(.bottom)
        }
    }
    
    private func descriptionBlock(for film: Film, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text(film.plot)
                .padding(.bottom)
            Divider()
            ActorsHorizontalScroll(title: isLocal ? "Top 5 cast" : "Top cast", items: film.actors, filmDetailViewModel: isLocal ? filmDetailViewModel : nil)
                .frame(width: geometry.size.width, height: geometry.size.width * 0.65)
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
