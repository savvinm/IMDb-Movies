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
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(Font.Weight.semibold)
                .padding(.leading)
            GeometryReader { geometry in
                horizontalList(in: geometry)
            }
        }
    }
    
    private func horizontalList(in geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(items) { film in
                    filmNavigationLink(for: film)
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height)
                        .modifier(HorizontallScrollPadding(item: film, items: items, padding: 5))
                }
            }
        }
    }
    
    private func filmNavigationLink(for film: Poster) -> some View {
        GeometryReader { geometry in
            NavigationLink(destination: { FilmDetailView(filmId: film.id) }, label: {
                filmPreviev(for: film, in: geometry)
            })
            .contentShape(TapShape())
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func filmPreviev(for film: Poster, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            imageWithRating(for: film)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
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
                ResizableAsyncImage(stringURL: film.imageURL)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .cornerRadius(10)
                if film.imdbRating != nil && film.imdbRating != "" {
                    RatingIcon(value: film.imdbRating!)
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                        .padding(4)
                }
            }
        }
    }
}
