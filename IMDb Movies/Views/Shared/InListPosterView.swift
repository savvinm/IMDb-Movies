//
//  InListPosterView.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 13.06.2022.
//

import SwiftUI

struct InListPosterView: View {
    let poster: Poster
    var body: some View {
        GeometryReader { geometry in
            NavigationLink(destination: FilmDetailView(filmId: poster.id), label: {
                HStack {
                    posterImage
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height)
                    textBlock
                }
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var textBlock: some View {
        VStack(alignment: .center) {
            Text(poster.title)
                //.multilineTextAlignment(.center)
            Text(poster.description ?? "")
                //.multilineTextAlignment(.leading)
            Spacer()
        }
        .multilineTextAlignment(.center)
        .font(.headline)
        .padding()
    }
    
    private var posterImage: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: poster.imageURL)) { image in
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
        }
    }
}
