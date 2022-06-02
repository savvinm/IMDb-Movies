//
//  PostersHorizontalScroll.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 02.06.2022.
//

import SwiftUI

struct PostersHorizontalScroll: View {
    let title: String
    let items: [Poster]
    let geometry: GeometryProxy
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
    
    private func filmNavigationLink(for film: Poster) -> some View {
        GeometryReader { geometry in
            NavigationLink(destination: { FilmDetailView(filmId: film.id) }, label: {
                filmPreviev(for: film, in: geometry)
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func filmPreviev(for film: Poster, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            imageWithRating(for: film)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
            Text(film.title)
                .font(.headline)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
    
    private func imageWithRating(for film: Poster) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Rectangle().foregroundColor(.clear)
                AsyncImage(url: URL(string: film.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                if film.imdbRating != nil && film.imdbRating != "" {
                    ratingIcon(value: film.imdbRating!)
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                        .padding(3)
                }
            }
        }
    }
    
    private func ratingIcon(value: String) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.85)
            Text(value)
        }
        .cornerRadius(5)
    }
}
