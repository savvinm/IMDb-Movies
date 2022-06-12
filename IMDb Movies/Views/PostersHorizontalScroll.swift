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
                ForEach(items) { film in
                    filmNavigationLink(for: film)
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.8)
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
                .foregroundColor(.black)
                .fontWeight(Font.Weight.medium)
        }
        .cornerRadius(5)
    }
}

struct TapShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path(CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
    }
}
